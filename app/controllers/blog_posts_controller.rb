class BlogPostsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_blog_post, only: %i[ show edit update destroy ai_revise revise_with_ai publish schedule cancel_schedule ]

  # GET /blog_posts or /blog_posts.json
  def index
    scope = user_signed_in? ? BlogPost.all : BlogPost.published
    @pagy, @blog_posts = pagy(scope.order(created_at: :desc))
  end

  # GET /blog_posts/1 or /blog_posts/1.json
  def show
  end

  # GET /blog_posts/new
  def new
    @blog_post = BlogPost.new
  end

  # GET /blog_posts/1/edit
  def edit
  end

  # POST /blog_posts or /blog_posts.json
  def create
    status, scheduled_at = resolve_publish_intent(
      params.dig(:blog_post, :status),
      params.dig(:blog_post, :scheduled_at)
    )
    @blog_post = current_user.blog_posts.new(
      blog_post_params.merge(status: status, scheduled_at: scheduled_at, human_generated: true)
    )

    respond_to do |format|
      if @blog_post.save
        format.html { redirect_to @blog_post, notice: publish_notice(status, scheduled_at, action: :created) }
        format.json { render :show, status: :created, location: @blog_post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blog_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blog_posts/1 or /blog_posts/1.json
  def update
    status, scheduled_at = resolve_publish_intent(
      params.dig(:blog_post, :status),
      params.dig(:blog_post, :scheduled_at)
    )

    respond_to do |format|
      if @blog_post.update(blog_post_params.merge(status: status, scheduled_at: scheduled_at))
        format.html { redirect_to @blog_post, notice: publish_notice(status, scheduled_at, action: :updated), status: :see_other }
        format.json { render :show, status: :ok, location: @blog_post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blog_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_posts/1 or /blog_posts/1.json
  def destroy
    @blog_post.destroy!

    respond_to do |format|
      format.html { redirect_to blog_posts_path, notice: "Blog post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # PATCH /blog_posts/:id/publish
  # Immediately publishes a draft or scheduled post.
  def publish
    @blog_post.published!
    redirect_to @blog_post, notice: "Post published successfully."
  end

  # PATCH /blog_posts/:id/schedule
  # Sets the post to scheduled with a future publish time.
  def schedule
    scheduled_at = params[:scheduled_at]

    if scheduled_at.blank?
      redirect_to @blog_post, alert: "Please choose a date and time to schedule."
      return
    end

    parsed_time = Time.zone.parse(scheduled_at)

    if parsed_time.nil? || parsed_time <= Time.current
      redirect_to @blog_post, alert: "Scheduled time must be in the future."
      return
    end

    @blog_post.update!(status: :scheduled, scheduled_at: parsed_time)
    redirect_to @blog_post, notice: "Post scheduled for #{parsed_time.strftime("%d %b %Y at %H:%M")}."
  end

  # PATCH /blog_posts/:id/cancel_schedule
  # Cancels a scheduled post and reverts it to draft.
  def cancel_schedule
    @blog_post.update!(status: :draft, scheduled_at: nil)
    redirect_to @blog_post, notice: "Schedule cancelled. Post reverted to draft."
  end

  # GET /blog_posts/ai_new
  # Renders the AI creation prompt form.
  def ai_new
  end

  # POST /blog_posts/create_with_ai
  # Creates a new blog post using the AI service from a user prompt.
  # Supports draft, publish, and schedule via the split button (status + scheduled_at params).
  def create_with_ai
    begin
      status, scheduled_at = resolve_publish_intent(
        ai_params[:status],
        ai_params[:scheduled_at]
      )

      service = BlogPostAiService.new(current_user)
      @blog_post = service.create_from_prompt(
        ai_params[:prompt],
        featured_image: ai_params[:featured_image],
        status: status,
        scheduled_at: scheduled_at
      )

      if @blog_post.persisted?
        redirect_to @blog_post, notice: publish_notice(status, scheduled_at, action: :ai_created)
      else
        flash.now[:alert] = "The AI response couldn't be saved: #{@blog_post.errors.full_messages.to_sentence}"
        @prompt = ai_params[:prompt]
        render :ai_new, status: :unprocessable_entity
      end
    rescue StandardError => e
      handle_ai_error(e, :ai_new)
    end
  end

  # GET /blog_posts/:id/ai_revise
  # Renders the AI revision form. Warns if the post still has a rich text body.
  def ai_revise
    @has_rich_text_body = @blog_post.body.present?
  end

  # PATCH /blog_posts/:id/revise_with_ai
  # Revises an existing blog post using the AI service.
  # Supports draft, publish, and schedule via the split button (status + scheduled_at params).
  def revise_with_ai
    begin
      status, scheduled_at = resolve_publish_intent(
        ai_params[:status],
        ai_params[:scheduled_at]
      )

      service = BlogPostAiService.new(current_user)
      keep = ai_params[:keep_featured_image] == "1"
      @blog_post = service.revise_blog_post(@blog_post, ai_params[:prompt],
        featured_image: ai_params[:featured_image],
        keep_featured_image: keep,
        status: status,
        scheduled_at: scheduled_at)

      if @blog_post.persisted?
        redirect_to @blog_post, notice: publish_notice(status, scheduled_at, action: :ai_revised)
      else
        flash.now[:alert] = "The AI revision couldn't be saved: #{@blog_post.errors.full_messages.to_sentence}"
        @prompt = ai_params[:prompt]
        @has_rich_text_body = @blog_post.body.present?
        render :ai_revise, status: :unprocessable_entity
      end
    rescue StandardError => e
      handle_ai_error(e, :ai_revise)
    end
  end

  private

  def set_blog_post
    @blog_post = BlogPost.friendly.find(params[:id])
  end

  # ai_generated and status/scheduled_at are handled outside blog_post_params:
  # - ai_generated is set by the AI service
  # - status/scheduled_at are resolved via resolve_publish_intent and merged in explicitly
  def blog_post_params
    params.expect(blog_post: [ :title, :slug, :blog_excerpt, :blog_post_erb_content, :body, :featured_image, :featured, photos: [] ])
  end

  def ai_params
    params.expect(blog_post: [ :prompt, :featured_image, :keep_featured_image, :status, :scheduled_at ])
  end

  # Parses the status + scheduled_at coming from the split button.
  # Returns [status_symbol, scheduled_at_or_nil].
  # Falls back to :draft if the scheduled time is missing or in the past.
  def resolve_publish_intent(raw_status, raw_scheduled_at)
    status = (raw_status.presence || "draft").to_sym

    if status == :scheduled
      parsed = raw_scheduled_at.present? ? Time.zone.parse(raw_scheduled_at.to_s) : nil
      if parsed.nil? || parsed <= Time.current
        return [ :draft, nil ]
      end
      return [ :scheduled, parsed ]
    end

    [ status, nil ]
  end

  # Returns a human-readable flash notice describing what happened to the post.
  def publish_notice(status, scheduled_at, action:)
    base = case action
           when :created    then "Blog post saved"
           when :updated    then "Blog post updated"
           when :ai_created then "Blog post created with AI"
           when :ai_revised then "Blog post revised with AI"
           end

    case status
    when :published then "#{base} and published."
    when :scheduled then "#{base} and scheduled for #{scheduled_at.strftime("%d %b %Y at %H:%M")}."
    else                 "#{base} as draft."
    end
  end

  def handle_ai_error(error, render_action)
    Rails.logger.error "AI error in BlogPostsController: #{error.message}"
    Rails.logger.error error.backtrace.join("\n")
    flash.now[:alert] = "The AI encountered an error. Please try again."
    @prompt = ai_params[:prompt] rescue nil
    render render_action, status: :unprocessable_entity
  end
end
