module TaskHelpers
  class Products
    class << self
      def ping
        Product.all.each do |product|
          PingProductJob.perform_now(product.id)
        end
      end
    end
  end
end
