class BlogPostsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_blog_post, only: %i[ show edit update destroy ai_revise revise_with_ai ]

  # GET /blog_posts or /blog_posts.json
  def index
    @blog_posts = BlogPost.all
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
    @blog_post = current_user.blog_posts.new(blog_post_params)

    respond_to do |format|
      if @blog_post.save
        format.html { redirect_to @blog_post, notice: "Blog post was successfully created." }
        format.json { render :show, status: :created, location: @blog_post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blog_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blog_posts/1 or /blog_posts/1.json
  def update
    respond_to do |format|
      if @blog_post.update(blog_post_params)
        format.html { redirect_to @blog_post, notice: "Blog post was successfully updated.", status: :see_other }
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

  # GET /blog_posts/ai_new
  # Renders the AI creation prompt form.
  def ai_new
  end

  # POST /blog_posts/create_with_ai
  # Creates a new blog post using the AI service from a user prompt.
  def create_with_ai
    begin
      service = BlogPostAiService.new(current_user)
      @blog_post = service.create_from_prompt(ai_params[:prompt])

      if @blog_post.persisted?
        redirect_to @blog_post, notice: "Blog post created with AI. Review and publish when ready."
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
  def revise_with_ai
    begin
      service = BlogPostAiService.new(current_user)
      @blog_post = service.revise_blog_post(@blog_post, ai_params[:prompt])

      if @blog_post.persisted?
        redirect_to @blog_post, notice: "Blog post revised with AI. Review the changes."
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

  # ai_generated is intentionally excluded — the AI service sets it automatically.
  def blog_post_params
    params.expect(blog_post: [ :title, :author, :status, :scheduled_at, :slug, :blog_post_erb_content, :body, photos: [] ])
  end

  def ai_params
    params.expect(blog_post: [ :prompt ])
  end

  def handle_ai_error(error, render_action)
    Rails.logger.error "AI error in BlogPostsController: #{error.message}"
    Rails.logger.error error.backtrace.join("\n")
    flash.now[:alert] = "The AI encountered an error. Please try again."
    @prompt = ai_params[:prompt] rescue nil
    render render_action, status: :unprocessable_entity
  end
end
