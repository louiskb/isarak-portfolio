class ResearchItemsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_research_item, only: %i[ show edit update destroy publish schedule cancel_schedule ]

  # GET /research_items
  # Public — visitors see published items; Isara sees all with status badges + Manage button
  def index
    scope = user_signed_in? ? ResearchItem.all : ResearchItem.published
    @pagy, @research_items = pagy(scope.order(:position, :created_at))
  end

  def reorder
    params[:ids].each_with_index do |id, index|
      ResearchItem.where(id: id).update_all(position: index)
    end
    head :ok
  end

  # GET /research_items/1
  # Public show page — visitors and Isara both see this
  def show
    unless user_signed_in?
      PostHog.capture(
        distinct_id: "anonymous",
        event: "research_item_viewed",
        properties: {
          title: @research_item.title,
          slug: @research_item.slug,
          category: @research_item.category
        }
      )
    end
  end

  # GET /research_items/new
  def new
    @research_item = ResearchItem.new
  end

  # GET /research_items/1/edit
  def edit
  end

  # POST /research_items
  def create
    status, scheduled_at = resolve_publish_intent(
      params.dig(:research_item, :status),
      params.dig(:research_item, :scheduled_at)
    )
    @research_item = current_user.research_items.new(
      research_item_params.merge(status: status, scheduled_at: scheduled_at)
    )

    respond_to do |format|
      if @research_item.save
        format.html { redirect_to @research_item, notice: publish_notice(status, scheduled_at, action: :created) }
        format.json { render :show, status: :created, location: @research_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @research_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /research_items/1
  def update
    status, scheduled_at = resolve_publish_intent(
      params.dig(:research_item, :status),
      params.dig(:research_item, :scheduled_at)
    )

    respond_to do |format|
      if @research_item.update(research_item_params.merge(status: status, scheduled_at: scheduled_at))
        format.html { redirect_to @research_item, notice: publish_notice(status, scheduled_at, action: :updated), status: :see_other }
        format.json { render :show, status: :ok, location: @research_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @research_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /research_items/1
  def destroy
    @research_item.destroy!

    respond_to do |format|
      format.html { redirect_to research_items_path, notice: "Research item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # PATCH /research_items/:id/publish
  def publish
    @research_item.published!
    redirect_to @research_item, notice: "Research item published successfully."
  end

  # PATCH /research_items/:id/schedule
  def schedule
    scheduled_at = params[:scheduled_at]

    if scheduled_at.blank?
      redirect_to @research_item, alert: "Please choose a date and time to schedule."
      return
    end

    parsed_time = Time.zone.parse(scheduled_at)

    if parsed_time.nil? || parsed_time <= Time.current
      redirect_to @research_item, alert: "Scheduled time must be in the future."
      return
    end

    @research_item.update!(status: :scheduled, scheduled_at: parsed_time)
    redirect_to @research_item, notice: "Research item scheduled for #{parsed_time.strftime("%d %b %Y at %H:%M")}."
  end

  # PATCH /research_items/:id/cancel_schedule
  def cancel_schedule
    @research_item.update!(status: :draft, scheduled_at: nil)
    redirect_to @research_item, notice: "Schedule cancelled. Reverted to draft."
  end

  private

  def set_research_item
    @research_item = ResearchItem.friendly.find(params[:id])
  end

  def research_item_params
    params.expect(research_item: [ :title, :category, :description, :card_summary, :external_url, :published_at, :authors, :image_url, :image, :featured, :slug ])
  end

  def resolve_publish_intent(raw_status, raw_scheduled_at)
    status = (raw_status.presence || "draft").to_sym

    if status == :scheduled
      parsed = raw_scheduled_at.present? ? Time.zone.parse(raw_scheduled_at.to_s) : nil
      return [ :draft, nil ] if parsed.nil? || parsed <= Time.current
      return [ :scheduled, parsed ]
    end

    [ status, nil ]
  end

  def publish_notice(status, scheduled_at, action:)
    base = action == :created ? "Research item saved" : "Research item updated"

    case status
    when :published then "#{base} and published."
    when :scheduled then "#{base} and scheduled for #{scheduled_at.strftime("%d %b %Y at %H:%M")}."
    else                 "#{base} as draft."
    end
  end
end
