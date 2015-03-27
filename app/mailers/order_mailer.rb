class OrderMailer < ActionMailer::Base
  default from: "info@biblesfornewzealand.org.nz"

  def confirmation_email(order)
    @customer = order.customer
    mail(to: @customer.email, subject: "Thank you for your request for free literature from Bibles for New Zealand")
  end
end
