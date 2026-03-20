class PublishScheduledPostsJob < ApplicationJob
  queue_as :default

  def perform
    due = ..Time.current

    BlogPost.scheduled.where(scheduled_at: due).find_each do |post|
      post.published!
      Rails.logger.info "PublishScheduledPostsJob: published BlogPost ##{post.id} \"#{post.title}\""
    end

    ResearchItem.scheduled.where(scheduled_at: due).find_each do |item|
      item.published!
      Rails.logger.info "PublishScheduledPostsJob: published ResearchItem ##{item.id} \"#{item.title}\""
    end

    Teaching.scheduled.where(scheduled_at: due).find_each do |item|
      item.published!
      Rails.logger.info "PublishScheduledPostsJob: published Teaching ##{item.id} \"#{item.title}\""
    end
  end
end
