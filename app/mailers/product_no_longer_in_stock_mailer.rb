class ProductNoLongerInStockMailer < ApplicationMailer
  def default_message
    @product = params[:product]
    mail(
      to: ENV["TO_EMAIL"],
      subject: "Product \"#{@product.name}\" is no longer in stock :("
    )
  end
end
