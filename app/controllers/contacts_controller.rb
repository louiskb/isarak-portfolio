class ContactsController < ApplicationController
  include HomePageContent

  skip_before_action :authenticate_user!, only: [ :new, :create ]
  invisible_captcha only: [ :create ]

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.valid?
      persist_and_deliver_contact!

      # PostHog: track successful contact form submission
      PostHog.capture(
        distinct_id: "anonymous",
        event: "contact_submitted"
      )

      redirect_to root_path(anchor: "contact"), notice: "Message sent! Check your email for confirmation."
    else
      render_contact_failure("Please correct the highlighted fields and try again.")
    end
  rescue StandardError => e
    Rails.logger.error("Contact form delivery failed: #{e.class} - #{e.message}")
    @contact = rebuild_contact_with_errors
    @contact.errors.add(:base, "We saved your message, but the email delivery failed. Please try again shortly.")
    render_contact_failure("We couldn't send your message right now. Please try again shortly.")
  end

  private

  def persist_and_deliver_contact!
    Contact.transaction do
      @contact.save!
      deliver_contact_emails!
    end
  end

  def deliver_contact_emails!
    ContactMailer.with(contact: @contact).received_email.deliver_now
    ContactMailer.with(contact: @contact).confirmation_email.deliver_now
  end

  def rebuild_contact_with_errors
    Contact.new(contact_params)
  end

  def render_contact_failure(message)
    load_home_page_content
    flash.now[:alert] = message
    render "pages/home", status: :unprocessable_entity
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :message)
  end
end
