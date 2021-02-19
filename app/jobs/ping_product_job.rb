class PingProductJob < ApplicationJob
  queue_as :products

  def perform(product_id)
    Rails.logger.info("Starting #{self.class.name}.")
    @product = Product.find(product_id)
    page_contents, succeeded = read_product_page_contents
    return if !succeeded
    in_stock = parse_is_in_stock?(page_contents)
    possibly_notify(in_stock)
  end

  private

  def read_product_page_contents
    file = URI.parse(@product.url).open
    [file.read, true]
  rescue StandardError => e
    Rails.logger.error("Failed to fetch product at url '#{@product.url}'")
    ["", false]
  end

  def possibly_notify(in_stock)
    if in_stock
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

  def parse_is_in_stock?(page_contents)
    if page_contents !~ /OUT OF STOCK/
      true
    else
      false
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
