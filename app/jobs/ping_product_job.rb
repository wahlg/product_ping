class PingProductJob < ApplicationJob
  queue_as :products

  def perform(product_id)
    Rails.logger.info("Starting #{self.class.name} job")
    product = Product.find_by!(id: product_id)
    file = URI.parse(product.url).open
    contents = file.read
    if contents !~ /OUT OF STOCK/
      Rails.logger.info("Product '#{product.name}' is in stock! Notifying.")
      notify(product)
    else
      Rails.logger.info("Product '#{product.name}' is still not in stock.")
    end
  end

  private

  def notify(product)
  end
end
