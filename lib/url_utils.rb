class UrlUtils
  class << self
    def domain_from_url(url)
      url = "http://#{url}" if URI.parse(url).scheme.nil?
      host = URI.parse(url).host.downcase
      host.start_with?('www.') ? host[4..-1] : host
    end
  end
end
