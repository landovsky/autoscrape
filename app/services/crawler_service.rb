class CrawlerService
  USER_AGENT = {'User-Agent' => 'Tomas Landovsky, +420722643643' }
  SLEEP = 2

  def self.call
    ListCrawlerService.call 'https://www.autodraft.cz/auta.html?cat=1'
    ListCrawlerService.call 'https://www.autodraft.cz/auta.html?cat=2'
    CarCrawlerService.call Car.available.crawled_hours_ago(6)
    CarParserService.call *Crawl.unparsed
  end

  def self.call!(*cars)
    CarCrawlerService.call cars
    CarParserService.call *Crawl.unparsed
  end
end