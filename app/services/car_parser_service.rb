class CarParserService
  attr_reader :crawl, :raw_page, :search, :features

  def initialize
    @features = {}
  end

  def self.call
    new.call
  end

  def call
    crawls = Crawl.all
    crawls.each do |crawl|
      @crawl = crawl
      # @crawl = crawls.first
      @search = Nokogiri::HTML @crawl.body
      parse_crawl
    end
  end

  def parse_crawl
    crawl.car.update_attributes parse_car_params

    begin
      crawl.car.features << parse_car_features
    rescue ActiveRecord::RecordInvalid
    end
  end

  def parse_car_params
    {
      title: search.css('h2.text-center.center-block').text.strip,
      manufactured: Date.parse(search.css('p.text-center.roboto.hidden-xs').children[1].text),
      odometer: search.css('p.text-center.roboto.hidden-xs').children[3].text.split(' ').join('').to_i,
      power_kw: find_car_param('Výkon') { |param| param.split(' ').first },
      transmission: text_to_enum(:transmission, find_car_param('Převodovka').downcase),
      fuel: text_to_enum(:fuel, find_car_param('Palivo').downcase)
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

  def text_to_enum(enum, text)
    I18n.locale = 'cs'
    car_params = I18n.t 'activerecord.attributes.car'
    result = car_params[enum].find { |k, v| v == text }.first
    I18n.locale = 'en'
    result
  end

  def find_car_param(name)
    car_params = search.css('div.row.paramsRow')
    param_to_find = car_params.find { |i| i.children.map(&:text).map(&:strip).reject(&:blank?).first == name } # find param block
                              .children.map(&:text).map(&:strip).reject(&:blank?) # clean block
    block_given? ? yield(param_to_find.last) : param_to_find.last
  end
end
