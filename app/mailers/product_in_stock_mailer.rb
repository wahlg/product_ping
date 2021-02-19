class ProductInStockMailer < ApplicationMailer
  def default_message
    @product = params[:product]
    mail(
      to: ENV["TO_EMAIL"],
      subject: "Product \"#{@product.name}\" is now in stock!"
    )
  end
end
