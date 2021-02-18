class PingProductJob < ApplicationJob
  queue_as :products

  def perform(product_id)
    Rails.logger.info("Starting #{self.class.name}.")
    product = Product.find(product_id)
    contents = read_product_url(product)
    in_stock = parse_is_in_stock?(contents)
    possibly_notify(in_stock, product)
  end

  private

  def read_product_url(product)
    file = URI.parse(product.url).open
    file.read
  end

  def possibly_notify(in_stock, product)
    if in_stock && !product.notified?
      notify_in_stock(product)
    elsif !in_stock
      if product.notified?
        notify_no_longer_in_stock(product)
      else
        log_still_not_in_stock
      end
    end
  end

  def parse_is_in_stock?(contents)
    if contents !~ /OUT OF STOCK/
      true
    else
      false
    end
  end

  def notify_in_stock(product)
    Rails.logger.info("Product '#{product.name}' is in stock!")
    EmailClient.send_notification_in_stock(product)
    product.mark_notified!
  end

  def notify_no_longer_in_stock(product)
    Rails.logger.info("Product '#{product.name}' is no longer in stock :(")
    EmailClient.send_notification_no_longer_in_stock(product)
    product.unmark_notified!
  end

  def log_still_not_in_stock
    Rails.logger.info("Product '#{product.name}' is still not in stock.")
  end
end
