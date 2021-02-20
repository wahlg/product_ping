module TaskHelpers
  class Products
    class << self
      def ping
        loop do
          Product.all.each do |product|
            PingProductJob.perform_later(product.id)
          end
          Rails.logger.info("Sleeping...")
          sleep 30
        end
      end
    end
  end
end
