# Fetch list
# - update car status (listing does not exist = sold)
# New car
# - create car
# - get some data from json
# - fetch and parse car detail
# Existing car
# - update price from json

# Parsing listing updates
# - car price
# - car status

# Parsing detail sets
# - year/month, vin, color, features

module Sauto
  BASE_URL = 'https://www.sauto.cz/'

  class ListCrawlerService
    attr_reader :raw_page, :search, :url

    def initialize(url)
      @url        = url
      @page_count = 0
    end

    def self.call(url = CrawlerService::SAUTO_VW)
      new(url).call
    rescue => e
      puts e
      puts e.backtrace[0..10]
    end

    def call
      pages = determine_page_count
      (1..pages).each do |page|
        @found_new_car = false
        go_to_page(page)
        parse_page_cars
        sleep CrawlerService::SLEEP.call
        # break unless @found_new_car
      end
    end

    def go_to_page(page)
      paged_url = url + "&page=#{page}"
      puts "Parsing #{paged_url}"
      @raw_page = open_page paged_url
      File.open('tmp/raw_page-sauto.json', 'w') { |f| f.write(JSON.dump @raw_page)}
    end

    def determine_page_count
      raw = open_page url
      raw['paging']['totalPages']
    end

    def parse_page_cars
      cars = raw_page['advert']
      puts "Found #{cars.count} cars"
      cars.each do |car_data|
        next if car_data['premise_name'] == 'AutoDraft'

        url = car_url(car_data)
        car = Car.find_by(url: url)
        if car.present?
          puts "UPDATING EXISTING CAR"
          car.update_price car_data['advert_price_total']
        else
          puts "FOUND NEW CAR"
          @found_new_car = true
          new_car = create_car(car_data, url)
          new_car.crawls << Crawl.new(body: car_data.to_json, format: :json)

          CarCrawlerService.call(*new_car)
        end
      end
    end

    def create_car(car_data, url)
      Car.create do |new_car|
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
      uri = URI.parse url
      response = Net::HTTP.get_response uri
      JSON.parse response.body
    end
  end
end
