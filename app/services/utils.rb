module Utils
  def open_url(url)
    uri = URI.parse url
    Net::HTTP.get_response(uri)
  rescue => e
    puts "Failed getting #{url}"
    puts e.backtrace[0..10]
    raise e
  end
end