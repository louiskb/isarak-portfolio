class BlogPostSchema < RubyLLM::Schema
  description "A structured academic blog post with a title, excerpt, HTML content, and an image search query"

  property :title,
    type: :string,
    description: "A clear, academic blog post title"

  property :excerpt,
    type: :string,
    description: "A 1-2 sentence plain-text summary of the post (no HTML). Shown as the preview on the blog index page. Keep it under 180 characters — compelling but concise."

  property :content,
    type: :string,
    description: "The full blog post content as semantic HTML. Use h2 and h3 for section headings, p for paragraphs, ul/ol/li for lists, blockquote for quotes. Do not include a wrapping html/body tag — content only."

  property :image_query,
    type: :string,
    description: "A short, descriptive Unsplash search query (2-4 words) to find a relevant header image. E.g. 'urban planning city', 'airport aviation', 'housing suburb'. Avoid abstract or people-focused queries — prefer landscapes, architecture, and urban environments."
end
