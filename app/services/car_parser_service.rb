class CarParserService
  attr_reader :crawl, :raw_page, :search, :features

  def initialize
    @features = {}
  end

  def self.call(car = nil)
    new.call(car)
  end

  def call(car)
    crawls = car.present? ? [car.crawls.last] : Crawl.all
    crawls.each do |crawl|
      @crawl = crawl
      @search = Nokogiri::HTML @crawl.body
      parse_crawl
    end
  end

  def parse_crawl
    crawl.car.update_attributes parse_car_params
    update_car_features
    update_car_sales_status
  end

  def update_car_sales_status
    new_status_raw = search.css('div#carousel-gallery').children.css('span').text.strip
    return if new_status_raw.blank?

    new_status = car_status_text_to_enum(:sales_status, new_status_raw.to_s).to_s
    return if crawl.car.car_status&.sales_status&.to_s == new_status

    crawl.car.car_statuses << CarStatus.new(sales_status: new_status)
  end

  def update_car_features
    crawl.car.features << parse_car_features
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
    }
  end

  def parse_car_features
    crawl_features = search.css('ul.glypList').children.map(&:text).map(&:strip).reject(&:blank?)
    crawl_features.map do |feature|
      features[feature] = Feature.find_or_create_by(title: feature)
    end
  end

  def find_price
    search.css('h2.xs-center').first.text.strip.split[0..-2].join('').to_i
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
    car_params = search.css('div.row.paramsRow')
    param_to_find = car_params.find { |i| i.children.map(&:text).map(&:strip).reject(&:blank?).first.downcase == name.downcase } # find param block
                              .children.map(&:text).map(&:strip).reject(&:blank?) # clean block
    block_given? ? yield(param_to_find.last) : param_to_find.last
  end
end
