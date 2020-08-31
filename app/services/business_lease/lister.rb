module BusinessLease
  BASE_URL = 'https://www.autapooperaku.cz'

  class Lister
    attr_reader :raw_page, :search, :url

    def initialize(url)
      @url                 = url
      @pages_with_new_cars = []
      @current_page        = nil
      @processed_pages     = 0
    end

    def self.call(url = CrawlerService::BUSINESS_LEASE)
      new(url).call
    rescue => e
      log e
      log e.backtrace[0..10]
    end

    def call
      @raw_page = open_page url
      @search   = Nokogiri::HTML raw_page
      parse_cars
    end

    def parse_cars
      cars = search.css('.carDet')
      log "Found #{cars.count} cars"
      cars.each do |raw|
        url = BASE_URL + raw.css('h2>a').first.attribute('href').value
        Car.find_or_create_by(url: url) do |car|
          @found_new_car = true
          car.source = :business_lease
          car.car_statuses.build
        end
      end
    end

    def open_page(url)
      uri = URI.parse url
      response = Net::HTTP.get_response uri
      response.body
    end

    def self.log(msg, level = :debug)
      ListCrawlerService.new.log(msg, level)
    end

    def log(msg, level = :debug)
      Rails.logger.send level, "BusinessLease::ListCrawlerService: #{msg}"
    end
  end
end
