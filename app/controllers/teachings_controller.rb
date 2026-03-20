class TeachingsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_teaching, only: %i[ show edit update destroy publish schedule cancel_schedule ]

  # GET /teachings
  # Public — visitors see published items; Isara sees all with status badges + Manage button
  def index
    scope = user_signed_in? ? Teaching.all : Teaching.published
    @pagy, @teachings = pagy(scope.order(:position, :created_at))
  end

  def reorder
    params[:ids].each_with_index do |id, index|
      Teaching.where(id: id).update_all(position: index)
    end
    head :ok
  end

  # GET /teachings/1
  # Public show page — visitors and Isara both see this
  def show
  end

  # GET /teachings/new
  def new
    @teaching = Teaching.new
  end

  # GET /teachings/1/edit
  def edit
  end

  # POST /teachings
  def create
    status, scheduled_at = resolve_publish_intent(
      params.dig(:teaching, :status),
      params.dig(:teaching, :scheduled_at)
    )
    @teaching = current_user.teachings.new(
      teaching_params.merge(status: status, scheduled_at: scheduled_at)
    )

    respond_to do |format|
      if @teaching.save
        format.html { redirect_to @teaching, notice: publish_notice(status, scheduled_at, action: :created) }
        format.json { render :show, status: :created, location: @teaching }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @teaching.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachings/1
  def update
    status, scheduled_at = resolve_publish_intent(
      params.dig(:teaching, :status),
      params.dig(:teaching, :scheduled_at)
    )

    respond_to do |format|
      if @teaching.update(teaching_params.merge(status: status, scheduled_at: scheduled_at))
        format.html { redirect_to @teaching, notice: publish_notice(status, scheduled_at, action: :updated), status: :see_other }
        format.json { render :show, status: :ok, location: @teaching }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @teaching.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachings/1
  def destroy
    @teaching.destroy!

    respond_to do |format|
      format.html { redirect_to teachings_path, notice: "Teaching was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # PATCH /teachings/:id/publish
  def publish
    @teaching.published!
    redirect_to @teaching, notice: "Teaching published successfully."
  end

  # PATCH /teachings/:id/schedule
  def schedule
    scheduled_at = params[:scheduled_at]

    if scheduled_at.blank?
      redirect_to @teaching, alert: "Please choose a date and time to schedule."
      return
    end

    parsed_time = Time.zone.parse(scheduled_at)

    if parsed_time.nil? || parsed_time <= Time.current
      redirect_to @teaching, alert: "Scheduled time must be in the future."
      return
    end

    @teaching.update!(status: :scheduled, scheduled_at: parsed_time)
    redirect_to @teaching, notice: "Teaching scheduled for #{parsed_time.strftime("%d %b %Y at %H:%M")}."
  end

  # PATCH /teachings/:id/cancel_schedule
  def cancel_schedule
    @teaching.update!(status: :draft, scheduled_at: nil)
    redirect_to @teaching, notice: "Schedule cancelled. Reverted to draft."
  end

  private

  def set_teaching
    @teaching = Teaching.friendly.find(params[:id])
  end

  def teaching_params
    params.expect(teaching: [ :title, :description, :institution, :year, :image_url, :image, :slug, :featured ])
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
    base = action == :created ? "Teaching saved" : "Teaching updated"

    case status
    when :published then "#{base} and published."
    when :scheduled then "#{base} and scheduled for #{scheduled_at.strftime("%d %b %Y at %H:%M")}."
    else                 "#{base} as draft."
    end
  end
end
