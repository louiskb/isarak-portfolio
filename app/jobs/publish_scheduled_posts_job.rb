class PublishScheduledPostsJob < ApplicationJob
  queue_as :default

  def perform
    BlogPost.scheduled.where(scheduled_at: ..Time.current).find_each do |post|
      post.published!
      Rails.logger.info "PublishScheduledPostsJob: published BlogPost ##{post.id} \"#{post.title}\""
    end
  end
end
