class ListCrawlerService
  attr_reader :raw_page, :search, :url

  def initialize(url)
    @url = url
  end

  def self.call(url = 'https://www.autodraft.cz/auta.html?cat=1&prevodovka=automat&showroom=PHA')
    new(url).call
  end

  def call
    pages = determine_page_count
    (1..pages).each do |page|
      @found_new_car = false
      at_page(page)
      sleep CrawlerService::SLEEP.call
      parse_cars
      break unless @found_new_car
    end
  end

  def at_page(page)
    paged_url = url + "&gpage=#{page}"
    puts "Parsing #{paged_url}"
    @raw_page = open_page paged_url
    @search   = Nokogiri::HTML raw_page
  end

  def determine_page_count
    raw = open_page url
    search = Nokogiri::HTML raw
    paging = search.css '.gui_list_paging_links_base'
    last_page = paging.map { |p| p.children.map(&:text).first }.reject(&:blank?).last
    last_page.to_i == 0 ? 1 : last_page.to_i
  end

  def parse_cars
    cars = search.css('.car-thumb')
    puts "Found #{cars.count} cars"
    cars.each do |raw|
      url = raw.css('a').attribute('href').value
      puts url
      Car.find_or_create_by(url: url) do |car|
        @found_new_car = true
        car.source = :autodraft
        car.car_statuses.build
      end
    end
  end

  def open_page(url)
    uri = URI.parse url
    response = Net::HTTP.get_response uri
    response.body
  end
end
