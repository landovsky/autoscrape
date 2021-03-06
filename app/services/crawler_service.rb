class CrawlerService
  USER_AGENT = {'User-Agent' => 'Tomas Landovsky, +420722643643' }
  SLEEP = proc { rand(290..2400) / 1000.to_f }

  SAUTO_VW = 'https://www.sauto.cz/hledani?ajax=2&sort=2&yearMin=2010&condition=4&condition=2&category=1&manufacturer=103&model=762&manufacturer=103&model=1615&manufacturer=103&model=765&manufacturer=103&model=771&nocache=658&page=1'
  BUSINESS_LEASE = 'https://www.autapooperaku.cz/vozy-na-prodej?znacka=5,7&model=9,26,44#itemCount=64'

  def self.all
    CrawlerService.autodraft
    CrawlerService.business_lease
  end

  def self.autodraft
    ListCrawlerService.call 'https://www.autodraft.cz/auta.html?cat=1'
    ListCrawlerService.call 'https://www.autodraft.cz/auta.html?cat=2'
    CarCrawlerService.call *Car.autodraft.available.crawled_hours_ago(6)
    CarParserService.call *Crawl.html.unparsed.joins(:car).merge(Car.autodraft)

    Car.autodraft.update_rating
  end

  def self.business_lease
    BusinessLease::Lister.call
    CarCrawlerService.call *Car.business_lease.available.crawled_hours_ago(6)
    BusinessLease::Parser::HTML.call *Crawl.html.unparsed.joins(:car).merge(Car.business_lease)

    Car.business_lease.update_rating
  end

  def self.sauto
    Sauto::ListCrawlerService.call SAUTO_VW
    Sauto::Parser::HTML.call *Crawl.html.unparsed.joins(:car).merge(Car.sauto)
  end

  def self.call(car)
    CarCrawlerService.call *car
    if car.autodraft?
      CarParserService.call *Crawl.html.unparsed.where(car: car).last
    else
      Sauto::Parser::HTML.call *Crawl.html.unparsed.where(car: car).last
    end
  end
end