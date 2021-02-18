module TaskHelpers
  class Products
    class << self
      def ping
        while true do
          Product.where(notified: false).each do |product|
            PingProductJob.perform_now(product.id)
          end
          Rails.logger.info("Sleeping...")
          sleep 30
        end
      end
    end
  end
end
