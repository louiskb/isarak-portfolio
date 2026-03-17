module HomePageContent
  extend ActiveSupport::Concern

  private

  def load_home_page_content
    @isara = User.first
    @service            = @isara&.service
    @featured_research  = ResearchItem.where(featured: true).order(updated_at: :desc).limit(4)
    @featured_teachings = Teaching.where(featured: true).order(updated_at: :desc).limit(3)
    @featured_grants    = GrantAward.order(:position, :created_at)
    @featured_posts     = BlogPost.published.where(featured: true).order(created_at: :desc).limit(3)
  end
end
