class SitemapsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @blog_posts = BlogPost.published.order(updated_at: :desc)
    @research_items = ResearchItem.published.order(updated_at: :desc)
    @teachings = Teaching.published.order(updated_at: :desc)
    @grant_awards = GrantAward.published.order(updated_at: :desc)

    expires_in 1.day, public: true
    respond_to do |format|
      format.xml { render layout: false }
    end
  end
end
