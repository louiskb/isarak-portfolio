class ContactsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :create ]
  invisible_captcha only: [ :create ]

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      ContactMailer.with(contact: @contact).received_email.deliver_now
      ContactMailer.with(contact: @contact).confirmation_email.deliver_now

      redirect_to root_path(anchor: "contact"), notice: "Message sent! Check your email for confirmation."
    else
      flash[:alert] = "Message failed to send!"
      redirect_to root_path(anchor: "contact")
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :message)
  end
end
