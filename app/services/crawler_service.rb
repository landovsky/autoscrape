class CrawlerService
  USER_AGENT = {'User-Agent' => 'Tomas Landovsky, +420722643643' }

  def self.call
    ListCrawlerService.call 'https://www.autodraft.cz/auta.html?cat=1&prevodovka=automat&showroom=PHA'
    ListCrawlerService.call 'https://www.autodraft.cz/auta.html?cat=2&prevodovka=automat&showroom=PHA'
    CarCrawlerService.call Car.available
    CarParserService.call Crawl.unparsed
  end
end