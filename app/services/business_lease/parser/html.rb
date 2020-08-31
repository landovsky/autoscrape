module BusinessLease
  module Parser
    class HTML
      attr_reader :car, :crawl, :raw_page, :search, :features, :force_parsing, :detail_params

      def initialize(force_parsing: false)
        @features = {}
        @force_parsing = force_parsing
      end

      def self.call(*crawls)
        new.call(crawls)
      end

      def self.call!(*crawls)
        new(force_parsing: true).call(crawls)
      end


      def call(crawls)
        crawls.each do |crawl|
          log "Parsing crawl id #{crawl.id}"
          @crawl = crawl
          @car = crawl.car
          @search = Nokogiri::HTML @crawl.body
          # next if listing_expired?
          parse_crawl
          crawl.parsed!
        end
      end

      def listing_expired?
        expired = search.css('div#expired').children.text.include? 'neexistuje'
        return false unless expired

        crawl.parsed!
        car.car_statuses << CarStatus.new(sales_status: :expired)
      end

      def parse_crawl
        if car.manufactured.blank?
          parse_base_care_info
          update_car_price
        else
          parse_base_care_info if force_parsing
          update_car_price
          # update_car_sales_status
        end
      end

      def parse_base_care_info
        car.update_attributes parse_car_params
        update_car_features
      end

      def update_car_sales_status
        new_status_raw = search.css('div#carousel-gallery').children.css('span').text.strip
        return if new_status_raw.blank?

        new_status = car_status_text_to_enum(:sales_status, new_status_raw.to_s).to_s
        return if car.car_status&.sales_status&.to_s == new_status

        car.car_statuses << CarStatus.new(sales_status: new_status)
      end

      def update_car_price
        new_car_price = find_price
        return if new_car_price.blank?
        return if car.price == new_car_price

        car.car_prices << CarPrice.new(price: new_car_price)
      end

      def update_car_features
        car.features << parse_car_features
      rescue ActiveRecord::RecordInvalid
        nil
      end

      def parse_car_params
        @detail_params = search.css 'table.tabParam'
        {
          title: search.css('div.content > h1').text,
          power_kw: find_car_param('Výkon').to_i,
          manufactured: Date.parse(find_car_param('Uvedení')),
          odometer: find_car_param('tachometru').to_i,
          color: find_car_param('Barva'),
          vin: find_car_param('VIN'),
          fuel: car_text_to_enum(:fuel, find_fuel),
          transmission: car_text_to_enum(:transmission, find_transmission)
        }
      end

      def parse_car_features
        crawl_features = search.css('div.moreParam')
                               .first.children[1].children
                               .map(&:text).reject(&:blank?).map { |i| i.split ',' }
                               .flatten
        crawl_features.map do |feature|
          features[feature] = Feature.find_or_create_by(title: feature) do |feat|
            feat.company = :business_lease
          end
        end
      end

      def find_fuel
        search.css('i.icon-ico_palivo').first.parent.children.last.text
      end

      def find_transmission
        search.css('i.icon-ico_prevodovka').first.parent.children.last.text
      end

      def find_price
        search.css('strong.price').first.text.split(' ')[0..1].join('').to_i
      end

      def car_text_to_enum(enum, text)
        text_to_enum :car, enum, text.downcase
      end

      def car_status_text_to_enum(enum, text)
        text_to_enum :car_status, enum, text
      end

      def text_to_enum(model, enum, text)
        I18n.locale = 'cs'
        model_params = I18n.t "activerecord.attributes.#{model}"
        result = model_params[enum].find { |k, v| v == text }.first
        I18n.locale = 'en'
        result
      rescue => e
        raise e
      end

      def find_car_param(name)
        param = detail_params.css('th').find { |i| i.text.include? name }
        param = param&.parent&.children&.last&.text
        block_given? ? yield(param) : param
      rescue => e
        raise e
      end

      def log(msg, level = :debug)
        Rails.logger.send level, "BusinessLease::Parser::HTML: #{msg}"
      end
    end
  end
end