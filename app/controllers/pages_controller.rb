class PagesController < ApplicationController
  include HomePageContent

  skip_before_action :authenticate_user!, only: [ :home, :download_cv ]

  def download_cv
    isara = User.first
    if isara&.cv&.attached?
      cloudinary_url = isara.cv.url
      download_url = cloudinary_url.sub("/upload/", "/upload/fl_attachment:Isara_Khanjanasthiti_CV/")
      redirect_to download_url, allow_other_host: true
    else
      redirect_to root_path, alert: "CV not available."
    end
  end

  def home
    load_home_page_content
    @contact = Contact.new
  end
end
