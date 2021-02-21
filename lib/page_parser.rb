class PageParser
  class << self
    def page_has_expected_content?(page_contents, domain)
      case domain
      when "bestbuy.com"
        return bestbuy_page_has_expected_content?(page_contents)
      when "newegg.com"
        return newegg_page_has_expected_content?(page_contents)
      else
        raise "Unrecognized domain '#{domain}'"
      end
    end

    def bestbuy_page_has_expected_content?(page_contents)
      if page_contents =~ /Add to Cart/ && page_contents !~ /Sold Out/
        true
      else
        false
      end
    end

    def newegg_page_has_expected_content?(page_contents)
      if page_contents =~ /In stock/ && page_contents !~ /OUT OF STOCK/
        true
      else
        false
      end
    end
  end
end
