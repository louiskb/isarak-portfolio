class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @isara = User.first
    @featured_research  = ResearchItem.where(featured: true).order(published_at: :desc, created_at: :desc).limit(6)
    @featured_teachings = Teaching.where(featured: true).limit(6)
    @featured_grants    = GrantAward.where(featured: true).limit(6)
    @featured_posts     = BlogPost.published.where(featured: true).order(created_at: :desc).limit(6)
    @contact = Contact.new
  end
end
