class PingProductJob < ApplicationJob
  queue_as :products

  def perform(product_id)
    Rails.logger.info("Starting #{self.class.name}.")
    @product = Product.find(product_id)
    page_contents, succeeded = read_product_page_contents
    return if !succeeded
    domain = UrlUtils.domain_from_url(@product.url)
    has_expected_content = PageParser.page_has_expected_content?(page_contents, domain)
    possibly_notify(has_expected_content)
  end

  private

  def read_product_page_contents
    file = URI.parse(@product.url).open
    contents = file.read
    if contents.blank?
      return [contents, false]
    end
    [contents, true]
  rescue StandardError => e
    Rails.logger.error("Failed to fetch product at url '#{@product.url}'")
    ["", false]
  end

  def possibly_notify(has_expected_content)
    if has_expected_content
      if @product.notified?
        log_still_in_stock
      else
        update_in_stock
      end
    else
      if @product.notified?
        update_no_longer_in_stock
      else
        log_still_not_in_stock
      end
    end
  end

  def update_in_stock
    Rails.logger.info("Product '#{@product.name}' changed to be in stock.")
    @product.mark_notified!
  end

  def update_no_longer_in_stock
    Rails.logger.info("Product '#{@product.name}' changed to be no longer in stock :(")
    @product.unmark_notified!
  end

  def log_still_in_stock
    Rails.logger.info("Product '#{@product.name}' remained in stock.")
  end

  def log_still_not_in_stock
    Rails.logger.info("Product '#{@product.name}' remained not in stock.")
  end
end
