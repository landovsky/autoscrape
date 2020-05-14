class CarCrawlerService
  attr_reader :raw_page, :search

  def self.call(cars)
    new.call(cars)
  end

  def call(cars)
    cars.each do |car|
      save_raw_page(car)
      sleep CrawlerService::SLEEP
    end
  end

  def save_raw_page(car)
    at_page(car.url)
    car.crawls << Crawl.new(body: raw_page)
  end

  def at_page(url)
    @raw_page = open_page url
    @search   = Nokogiri::HTML raw_page
  end

  def open_page(url)
    uri = URI.parse url
    response = Net::HTTP.get_response uri
    response.body
  end
end
