class CarCrawlerService
  def self.call(*cars)
    new.call(cars)
  end

  def call(cars)
    cars.each do |car|
      save_raw_page(car)
      sleep CrawlerService::SLEEP.call
    end
  end

  def save_raw_page(car)
    raw_page = open_page car.url
    car.crawls << Crawl.new(body: raw_page, format: :html)
  end

  def open_page(url, attempt = 0)
    uri      = URI.parse url
    response = Net::HTTP.get_response uri

    attempt += 1
    response['location'].present? && attempt < 4 ? open_page(response['location'], attempt) : response.body
  end
end
