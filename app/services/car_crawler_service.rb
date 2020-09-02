class CarCrawlerService
  include Utils

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
    car.crawls << Crawl.new(body: raw_page, format: :html) if raw_page
  end

  def open_page(car)
    response = open_url(car.url)

    if response.body.present?
      response.body
    elsif response['location'].present? && car.business_lease? && ['velke-a-uzitkove-vozy', 'stredni-vozy'].include?(response['location'].split('/').last)
      car.car_statuses << CarStatus.new(sales_status: :sold)
      false
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
end
