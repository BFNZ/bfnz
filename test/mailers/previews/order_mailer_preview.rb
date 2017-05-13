class OrderMailerPreview < ActionMailer::Preview

  def confirmation_email
    OrderMailer.confirmation_email(Order.last)
  end
end
