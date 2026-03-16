class PagesController < ApplicationController
  include HomePageContent

  skip_before_action :authenticate_user!, only: [ :home, :download_cv ]

  def download_cv
    isara = User.first
    if isara&.cv&.attached?
      url = isara.cv.url.sub("/upload/", "/upload/fl_attachment:isara_khanjanasthiti_cv/")
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
