class PagesController < ApplicationController
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
    @isara = User.first
    @service            = @isara&.service
    @featured_research  = ResearchItem.where(featured: true).order(published_at: :desc, created_at: :desc).limit(4)
    @featured_teachings = Teaching.where(featured: true).limit(3)
    @featured_grants    = GrantAward.where(featured: true)
    @featured_posts     = BlogPost.published.where(featured: true).order(created_at: :desc).limit(3)
    @contact = Contact.new
  end
end
