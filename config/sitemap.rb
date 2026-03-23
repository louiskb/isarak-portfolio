require "rubygems"
require "sitemap_generator"

app_host = ENV.fetch("APP_HOST", "isarak.me")
app_host = "https://#{app_host}" unless app_host.start_with?("http")
SitemapGenerator::Sitemap.default_host = app_host
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Interpreter.send :include, Rails.application.routes.url_helpers

SitemapGenerator::Sitemap.create do
  # Static pages
  add root_path, changefreq: "weekly", priority: 1.0
  add blog_posts_path, changefreq: "daily", priority: 0.9
  add research_items_path, changefreq: "weekly", priority: 0.8
  add teachings_path, changefreq: "monthly", priority: 0.7

  # Blog posts
  BlogPost.published.find_each do |post|
    add blog_post_path(post),
        lastmod: post.updated_at,
        changefreq: "monthly",
        priority: 0.8
  end

  # Research items
  ResearchItem.published.find_each do |item|
    add research_item_path(item),
        lastmod: item.updated_at,
        changefreq: "monthly",
        priority: 0.7
  end

  # Teaching entries
  Teaching.published.find_each do |teaching|
    add teaching_path(teaching),
        lastmod: teaching.updated_at,
        changefreq: "monthly",
        priority: 0.6
  end
end
