class PagesController < ApplicationController
  include HomePageContent

  skip_before_action :authenticate_user!, only: [ :home, :download_cv ]

  def download_cv
    isara = User.first
    if isara&.cv&.attached?
      blob = isara.cv.blob
      public_id = "#{Rails.env}/#{blob.key}"
      url = Cloudinary::Utils.private_download_url(
        public_id,
        blob.filename.extension_without_delimiter,
        resource_type: "image",
        attachment: true
      )
      redirect_to url, allow_other_host: true
    else
      redirect_to root_path, alert: "CV not available."
    end
  end

  def home
    load_home_page_content
    @contact = Contact.new
  end
end
