class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :authenticate_user!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def configure_permitted_parameters
    # For additional fields in `app/views/devise/registrations/new.html.erb`
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # For additional fields in `app/views/devise/registrations/edit.html.erb`
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
