class ContactMailer < ApplicationMailer
  def received_email
    @contact = params[:contact]
    mail(
      to: ENV.fetch("MAILER_SENDER", nil),
      subject: "New Contact: #{@contact.first_name} #{@contact.last_name}",
      reply_to: @contact.email
    )
  end

  def confirmation_email
    @contact = params[:contact]
    mail(
      to: @contact.email,
      from: ENV.fetch("MAILER_SENDER", nil),
      subject: "Message received!"
    )
  end
end
