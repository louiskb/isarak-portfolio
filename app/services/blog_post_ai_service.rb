require "net/http"
require "json"

class BlogPostAiService
  UNSPLASH_API_URL = "https://api.unsplash.com/photos/random"

  def initialize(user)
    @user = user
  end

  # Creates a brand-new blog post from a user prompt.
  # Returns the BlogPost instance (persisted if successful, unpersisted with errors if not).
  def create_from_prompt(prompt)
    chat = RubyLLM.chat(model: "gpt-4o")
    chat.with_instructions(creation_system_prompt)

    response = chat.ask(prompt, with: BlogPostSchema)

    image_html = fetch_image_html(response.image_query)
    content = "#{image_html}#{response.content}"

    blog_post = @user.blog_posts.build(
      title: response.title,
      blog_post_erb_content: content,
      ai_generated: true,
      status: :draft
    )

    blog_post.save
    blog_post
  end

  # Revises an existing blog post using the given revision prompt.
  # Uses the post's current content (rich text body OR erb content) as context for the AI.
  # After revision, stores the result in blog_post_erb_content and clears the rich text body.
  # Returns the BlogPost instance.
  def revise_blog_post(blog_post, revision_prompt)
    current_content = if blog_post.blog_post_erb_content.present?
      blog_post.blog_post_erb_content
    elsif blog_post.body.present?
      blog_post.body.to_plain_text
    else
      ""
    end

    chat = RubyLLM.chat(model: "gpt-4o")
    chat.with_instructions(revision_system_prompt(blog_post, current_content))

    response = chat.ask(revision_prompt, with: BlogPostSchema)

    image_html = fetch_image_html(response.image_query)
    content = "#{image_html}#{response.content}"

    blog_post.assign_attributes(
      title: response.title,
      blog_post_erb_content: content,
      ai_generated: true
    )

    # Clear the rich text body — the AI has now used it as a reference.
    # Going forward this post is managed via blog_post_erb_content only.
    blog_post.body = nil

    blog_post.save
    blog_post
  end

  private

  # Fetches a relevant image from Unsplash and returns a ready-to-inject HTML string.
  # Returns an empty string if the API key is missing or the request fails — so a failed image fetch never blocks the post from saving.
  def fetch_image_html(query)
    access_key = ENV["UNSPLASH_ACCESS_KEY"]
    return "" if access_key.blank? || query.blank?

    uri = URI(UNSPLASH_API_URL)
    uri.query = URI.encode_www_form(
      query: query,
      orientation: "landscape",
      client_id: access_key
    )

    response = Net::HTTP.get_response(uri)
    return "" unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    image_url        = data.dig("urls", "regular")
    photographer     = data.dig("user", "name")
    photographer_url = "#{data.dig("user", "links", "html")}?utm_source=isarak_portfolio&utm_medium=referral"
    photo_url        = "#{data.dig("links", "html")}?utm_source=isarak_portfolio&utm_medium=referral"

    return "" if image_url.blank?

    # Unsplash terms require attribution — photographer name and Unsplash link are mandatory.
    "<figure class='mb-4'>" \
      "<img src='#{image_url}' alt='#{query}' class='img-fluid rounded' style='width:100%;max-height:420px;object-fit:cover;'>" \
      "<figcaption class='text-muted mt-1' style='font-size:0.8em;'>" \
        "Photo by <a href='#{photographer_url}'>#{photographer}</a> on " \
        "<a href='#{photo_url}'>Unsplash</a>" \
      "</figcaption>" \
    "</figure>"
  rescue StandardError => e
    Rails.logger.warn "Unsplash image fetch failed: #{e.message}"
    ""
  end

  def creation_system_prompt
    <<~PROMPT
      ## Persona
      You are an expert academic writer and web developer assisting Dr Isara Khanjanasthiti — an urban and regional planning academic at the University of New England (UNE), Sydney campus. Dr Isara's research covers aviation, cross-border governance, housing affordability, and university teaching and learning.

      ## Context
      You are writing a blog post for Dr Isara's professional portfolio website. The audience is a mix of academics, students, and professionals interested in urban planning and related fields. The website uses a dark theme with the following color scheme:
      - Primary / accent: teal `#89D6CC`
      - Page background: `#080808`
      - Surface / card background: `#2D2D2D`
      - Body text: `#E2E2E2`
      - Borders: `#3D3D3D`

      ## Task
      Write a full blog post for Dr Isara based on the topic provided. The tone should be scholarly but accessible — explain jargon where used. Write in first person where it feels natural ("In my research...", "I have found..."). Target length: 400–700 words of content (excluding the title).

      ## Format
      Return three fields: `title`, `content`, and `image_query`.

      **`image_query`**: A short 2–4 word Unsplash search query for a relevant header image. Prefer landscape, architecture, or urban environment searches (e.g. "urban planning city", "airport terminal", "suburban housing"). Avoid people-focused or abstract queries.

      **`content`**: The full blog post as a plain HTML string — no JSON, no Markdown, no code fences. Follow these rules exactly:
      1. Use single quotes for all HTML attribute values (e.g. class='...' not class="...")
      2. Escape any apostrophes inside attribute values with a backslash (e.g. data-label='it\\'s')
      3. Do NOT include the title — the `title` field handles that separately
      4. Do NOT wrap content in <html>, <body>, <head>, <article>, or <div class='container'> — your code is already injected inside <div class='container'><article>…</article></div>
      5. Start the post body with an <h2> tag — <h1> is already used at the top of the page for the title
      6. Use semantic HTML: h2, h3, p, ul, ol, li, blockquote, code
      7. For <code> blocks: add a border and light gray background using inline styles (e.g. style='background:#f3f4f6;border:1px solid #d1d5db;border-radius:4px;padding:2px 6px;')
      8. Prefer Bootstrap utility classes for styling (e.g. class='text-info' for teal accents, class='text-muted' for secondary text, class='fw-bold' for bold). Use inline styles only when no suitable Bootstrap class exists — do NOT add custom font-family styles
      9. You may use bold, italic, underline, and inline color where it adds meaning — keep colors consistent with the teal/dark theme above
      10. Remove any numbered citations in brackets (e.g. [1], [2])
      11. No <script> or <style> elements
      12. No target='_blank' attributes — these may be sanitized
      13. Optimize content for SEO: use relevant keywords naturally in headings and the opening paragraph
      14. Return the HTML as a single unformatted string with no line breaks between tags — easy to store in a database field
    PROMPT
  end

  def revision_system_prompt(blog_post, current_content)
    <<~PROMPT
      ## Persona
      You are an expert academic writer and web developer assisting Dr Isara Khanjanasthiti — an urban and regional planning academic at the University of New England (UNE), Sydney campus.

      ## Context
      You are revising an existing blog post on Dr Isara's professional portfolio website. The website uses a dark theme with the following color scheme:
      - Primary / accent: teal `#89D6CC`
      - Page background: `#080808`
      - Surface / card background: `#2D2D2D`
      - Body text: `#E2E2E2`
      - Borders: `#3D3D3D`

      The current post to revise is:

      TITLE: #{blog_post.title}

      CURRENT CONTENT:
      #{current_content}

      ---

      ## Task
      Revise this blog post based on Dr Isara's instructions. Preserve the overall structure and tone unless explicitly told to change them. Return the revised `title`, the full revised `content`, and a fresh `image_query`.

      ## Format
      Return three fields: `title`, `content`, and `image_query`.

      **`image_query`**: A short 2–4 word Unsplash search query for a relevant header image. Prefer landscape, architecture, or urban environment searches (e.g. "urban planning city", "airport terminal", "suburban housing"). Avoid people-focused or abstract queries.

      **`content`**: The full revised blog post as a plain HTML string — no JSON, no Markdown, no code fences. Follow these rules exactly:
      1. Use single quotes for all HTML attribute values (e.g. class='...' not class="...")
      2. Escape any apostrophes inside attribute values with a backslash (e.g. data-label='it\\'s')
      3. Do NOT include the title — the `title` field handles that separately
      4. Do NOT wrap content in <html>, <body>, <head>, <article>, or <div class='container'> — your code is already injected inside <div class='container'><article>…</article></div>
      5. Start the post body with an <h2> tag — <h1> is already used at the top of the page for the title
      6. Use semantic HTML: h2, h3, p, ul, ol, li, blockquote, code
      7. For <code> blocks: add a border and light gray background using inline styles (e.g. style='background:#f3f4f6;border:1px solid #d1d5db;border-radius:4px;padding:2px 6px;')
      8. Prefer Bootstrap utility classes for styling (e.g. class='text-info' for teal accents, class='text-muted' for secondary text, class='fw-bold' for bold). Use inline styles only when no suitable Bootstrap class exists — do NOT add custom font-family styles
      9. You may use bold, italic, underline, and inline color where it adds meaning — keep colors consistent with the teal/dark theme above
      10. Remove any numbered citations in brackets (e.g. [1], [2])
      11. No <script> or <style> elements
      12. No target='_blank' attributes — these may be sanitized
      13. Optimize content for SEO: use relevant keywords naturally in headings and the opening paragraph
      14. Return the HTML as a single unformatted string with no line breaks between tags — easy to store in a database field
    PROMPT
  end
end
