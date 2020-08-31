class CarParserService
  attr_reader :car, :crawl, :raw_page, :search, :features, :force_parsing

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
      parse_crawl
      crawl.parsed!
    end
  end

  def parse_crawl
    if car.title.blank?
      parse_base_care_info
    else
      parse_base_care_info if force_parsing
      car.update_price(find_price)
      update_car_sales_status
    end
  end

  def parse_base_care_info
    car.update_attributes parse_car_params
    update_car_features
    set_car_price
  end

  def update_car_sales_status
    new_status_raw = search.css('div#carousel-gallery').children.css('span').text.strip
    return if new_status_raw.blank?

    new_status = car_status_text_to_enum(:sales_status, new_status_raw.to_s).to_s
    return if car.car_status&.sales_status&.to_s == new_status

    car.car_statuses << CarStatus.new(sales_status: new_status)
  end

  def set_car_price
    return if car.price.present?

    car.car_prices << CarPrice.new(price: find_price)
  end

  def update_car_features
    car.features << parse_car_and_create_features
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def parse_car_params
    {
      title: search.css('h2.text-center.center-block').text.strip,
      manufactured: Date.parse(search.css('p.text-center.roboto.hidden-xs').children[1].text),
      odometer: search.css('p.text-center.roboto.hidden-xs').children[3].text.split(' ').join('').to_i,
      power_kw: find_car_param('Výkon') { |param| param.split(' ').first },
      transmission: car_text_to_enum(:transmission, find_car_param('Převodovka').downcase),
      fuel: car_text_to_enum(:fuel, find_car_param('Palivo').downcase),
      vin: find_car_param('Vin') { |param| param.split(' ').first },
      color: find_car_param('Barva'),
      color_hex: find_color_code
    }
  end

  def parse_car_and_create_features
    crawl_features = search.css('ul.glypList').children.map(&:text).map(&:strip).reject(&:blank?)
    crawl_features.map do |feature|
      features[feature] = Feature.find_or_create_by(title: feature.downcase) do |feat|
        feat.company = :autodraft
      end
    end
  end

  def find_price
    search.css('h2.xs-center').first.text.strip.split[0..-2].join('').to_i
  rescue => e
    binding.pry
    raise e
  end

  def find_color_code
    car_param_block('Barva').children[-2].children.map { |i| i.attribute('style')&.value }.compact.first.split('#').last.gsub(';', '')
  end

  def car_text_to_enum(enum, text)
    text_to_enum :car, enum, text
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
  end

  def find_car_param(name)
    param = car_param_block(name) do |block|
      block.children.map(&:text).map(&:strip).reject(&:blank?) # clean block
    end
    block_given? ? yield(param.last) : param.last
  end

  def car_param_block(name)
    car_params = search.css('div.row.paramsRow')
    param_block = car_params.find { |i| i.children.map(&:text).map(&:strip).reject(&:blank?).first.downcase == name.downcase } # find param block
    block_given? ? yield(param_block) : param_block
  end

  def log(msg, level = :debug)
    Rails.logger.send level, "Autodraft::ListCrawlerService: #{msg}"
  end
end
