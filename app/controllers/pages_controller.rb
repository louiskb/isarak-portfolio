class PagesController < ApplicationController
  include HomePageContent

  skip_before_action :authenticate_user!, only: [ :home, :download_cv ]

  def download_cv
    isara = User.first
    if isara&.cv&.attached?
      send_data isara.cv.download,
                filename: "Isara_Khanjanasthiti_CV.pdf",
                type: "application/pdf",
                disposition: "attachment"
    else
      redirect_to root_path, alert: "CV not available."
    end
  end

  def home
    load_home_page_content
    @contact = Contact.new
  end
end
