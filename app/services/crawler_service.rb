class CrawlerService
  def self.call
    ListCrawlerService.call
    CarCrawlerService.call Car.without_crawl
    CarParserService.call Crawl.unparsed
  end
end