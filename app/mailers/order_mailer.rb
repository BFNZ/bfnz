class OrderMailer < ActionMailer::Base
  default from: "info@biblesfornewzealand.org.nz"

  def confirmation_email(order)
    @order = order
    mail(to: order.email, subject: "Thank you for your request for free literature from Bibles for New Zealand")
  end
end
