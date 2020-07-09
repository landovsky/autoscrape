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
    raw_page = open_page car
    car.crawls << Crawl.new(body: raw_page, format: :html)
  end

  def open_page(car)
    response = open_url(car.url)

    if response.body.present?
      response.body
    elsif response['location'].present?
      new_url = response['location']
      response = open_url new_url

      car.update(url: new_url) if response.body.present?
      raise "Page content missing after redirect" unless response.present?
      response.body
    else
      raise "Page content missing"
    end
  end

  def open_url(url)
    uri      = URI.parse url
    Net::HTTP.get_response uri
  end
end
