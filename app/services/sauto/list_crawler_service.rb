module Sauto
  include Utils

  BASE_URL = 'https://www.sauto.cz/'

  class ListCrawlerService
    attr_reader :raw_page, :search, :url

    def initialize(url)
      @url                 = url
      @pages_with_new_cars = []
      @current_page        = nil
      @processed_pages     = 0
    end

    def self.call(url = CrawlerService::SAUTO_VW)
      new(url).call
    rescue => e
      log e
      log e.backtrace[0..10]
    end

    def call
      pages = determine_page_count

      (1..pages).each do |page|
        @current_page = page
        go_to_page(page)
        parse_page_cars
        # break unless found_car_recently?
        @processed_pages += 1
        sleep CrawlerService::SLEEP.call
      end
    end

    def go_to_page(page)
      paged_url = url + "&page=#{page}"
      log "Parsing #{paged_url}"
      @raw_page = open_page paged_url
      File.open('tmp/raw_page-sauto.json', 'w') { |f| f.write(JSON.dump @raw_page)}
    end

    def determine_page_count
      raw = open_page url
      raw['paging']['totalPages']
    end

    def parse_page_cars
      cars = raw_page['advert']
      log "Found #{cars.count} cars"
      cars.each do |car_data|
        next if car_data['premise_name'] == 'AutoDraft'

        url = car_url(car_data)
        car = Car.find_by(url: url)
        if car.present?
          car.update_price car_data['advert_price_total']
        else
          @pages_with_new_cars << @current_page
          new_car = create_car(car_data, url)
          new_car.crawls << Crawl.new(body: car_data.to_json, format: :json)

          CarCrawlerService.call *new_car
        end
      end
    end

    def found_car_recently?
      if @pages_with_new_cars.present?
        @current_page - @pages_with_new_cars.last < 3
      elsif
        @processed_pages < 3
      end
    end

    def create_car(car_data, url)
      Car.create! do |new_car|
        new_car.car_statuses << CarStatus.new(sales_status: :on_sale, created_at: Date.parse(car_data['advert_since']))
        new_car.car_prices << CarPrice.new(price: car_data['advert_price_total'])

        new_car.assign_attributes Sauto::Parser::JSON.call(car_data)
        new_car.url = url
      end
    end

    def car_url(car)
      Sauto::BASE_URL + car['advert_url'] + car['advert_id'].to_s
    end

    def open_page(url)
      response = open_url(url).body
      JSON.parse response.body
    end

    def log(msg, level = :debug)
      Rails.logger.send level, "Sauto::ListCrawlerService: #{msg}"
    end
  end
end
