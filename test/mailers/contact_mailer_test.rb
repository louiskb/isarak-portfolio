require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  setup do
    @contact = Contact.new(
      first_name: "Louis",
      last_name: "Bourne",
      email: "louis@example.com",
      message: "Hello from the contact form."
    )
  end

  test "received email replies directly to the contact sender" do
    email = ContactMailer.with(contact: @contact).received_email

    assert_equal [ENV.fetch("MAILER_SENDER", nil)], email.to
    assert_includes email[:from].decoded, "Louis Bourne via Dr Isara Khanjanasthiti"
    assert_includes email[:from].decoded, ENV.fetch("MAILER_SENDER", nil)
    assert_equal ["louis@example.com"], email.reply_to
  end

  test "confirmation email sends directly to the contact without bcc or reply-to override" do
    email = ContactMailer.with(contact: @contact).confirmation_email

    assert_equal ["louis@example.com"], email.to
    assert_nil email.bcc
    assert_nil email.reply_to
  end
end
