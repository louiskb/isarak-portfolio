module HomePageContent
  extend ActiveSupport::Concern

  private

  def load_home_page_content
    @isara = User.first
    @service            = @isara&.service
    @featured_research  = ResearchItem.where(featured: true).order(published_at: :desc, created_at: :desc).limit(4)
    @featured_teachings = Teaching.where(featured: true).limit(3)
    @featured_grants    = GrantAward.where(featured: true)
    @featured_posts     = BlogPost.published.where(featured: true).order(created_at: :desc).limit(3)
  end
end
