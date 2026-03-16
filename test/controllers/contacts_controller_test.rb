require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  test "should create contact and send both emails" do
    params = build_contact_form_params(
      first_name: "Louis",
      last_name: "Bourne",
      email: "louis@example.com",
      message: "Hello from the contact form."
    )

    assert_difference("Contact.count", 1) do
      travel 6.seconds do
        assert_emails 2 do
          post contacts_url, params: params
        end
      end
    end

    assert_redirected_to root_url(anchor: "contact")
    follow_redirect!
    assert_match "Message sent! Check your email for confirmation.", @response.body
  end

  test "should re-render home with validation errors when contact is invalid" do
    params = build_contact_form_params(
      first_name: "",
      last_name: "Bourne",
      email: "not-an-email",
      message: ""
    )

    travel 6.seconds do
      assert_no_difference("Contact.count") do
        post contacts_url, params: params
      end
    end

    assert_response :unprocessable_entity
    assert_match "Please correct the highlighted fields and try again.", @response.body
    assert_match "First name can&#39;t be blank", @response.body
    assert_match "Email is invalid", @response.body
    assert_match "Message can&#39;t be blank", @response.body
  end

  test "should block spam submission when captcha spinner is invalid" do
    params = build_contact_form_params(
      first_name: "Spam",
      last_name: "Bot",
      email: "spam@example.com",
      message: "This should be blocked."
    )
    params[:spinner] = "invalid-spinner"

    travel 6.seconds do
      assert_no_difference("Contact.count") do
        assert_emails 0 do
          post contacts_url, params: params
        end
      end
    end

    assert_response :success
    assert_empty @response.body
  end

  private

  def build_contact_form_params(first_name:, last_name:, email:, message:)
    get root_url(anchor: "contact")

    spinner_input = css_select("input[name='spinner']").first
    honeypot_input = css_select("input[tabindex='-1']").find { |input| input["name"] != "spinner" }

    {
      contact: {
        first_name: first_name,
        last_name: last_name,
        email: email,
        message: message
      },
      spinner: spinner_input["value"],
      honeypot_input["name"] => ""
    }
  end
end
