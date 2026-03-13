class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :download_cv ]

  def download_cv
    isara = User.first
    if isara&.cv&.attached?
      blob = isara.cv.blob
      send_data blob.download,
                filename: "Isara_Khanjanasthiti_CV.pdf",
                type: blob.content_type,
                disposition: "attachment"
    else
      redirect_to root_path, alert: "CV not available."
    end
  end

  def home
    @isara = User.first
    @featured_research  = ResearchItem.where(featured: true).order(published_at: :desc, created_at: :desc).limit(6)
    @featured_teachings = Teaching.where(featured: true).limit(6)
    @featured_grants    = GrantAward.where(featured: true).limit(6)
    @featured_posts     = BlogPost.published.where(featured: true).order(created_at: :desc).limit(6)
    @contact = Contact.new
  end
end
