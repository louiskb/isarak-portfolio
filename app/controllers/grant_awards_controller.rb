class GrantAwardsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_grant_award, only: %i[ show edit update destroy publish schedule cancel_schedule ]

  # GET /grant_awards
  # Public — visitors see published items; Isara sees all with status badges + Manage button
  def index
    scope = user_signed_in? ? GrantAward.all : GrantAward.published
    @pagy, @grant_awards = pagy(scope.order(:position, :created_at))
  end

  def reorder
    params[:ids].each_with_index do |id, index|
      GrantAward.where(id: id).update_all(position: index)
    end
    head :ok
  end

  # GET /grant_awards/1
  def show
  end

  # GET /grant_awards/new
  def new
    @grant_award = GrantAward.new
  end

  # GET /grant_awards/1/edit
  def edit
  end

  # POST /grant_awards
  def create
    status, scheduled_at = resolve_publish_intent(
      params.dig(:grant_award, :status),
      params.dig(:grant_award, :scheduled_at)
    )
    @grant_award = current_user.grant_awards.new(
      grant_award_params.merge(status: status, scheduled_at: scheduled_at)
    )

    respond_to do |format|
      if @grant_award.save
        format.html { redirect_to @grant_award, notice: publish_notice(status, scheduled_at, action: :created) }
        format.json { render :show, status: :created, location: @grant_award }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grant_award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grant_awards/1
  def update
    status, scheduled_at = resolve_publish_intent(
      params.dig(:grant_award, :status),
      params.dig(:grant_award, :scheduled_at)
    )

    respond_to do |format|
      if @grant_award.update(grant_award_params.merge(status: status, scheduled_at: scheduled_at))
        format.html { redirect_to @grant_award, notice: publish_notice(status, scheduled_at, action: :updated), status: :see_other }
        format.json { render :show, status: :ok, location: @grant_award }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grant_award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grant_awards/1
  def destroy
    @grant_award.destroy!

    respond_to do |format|
      format.html { redirect_to grant_awards_path, notice: "Grant award was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # PATCH /grant_awards/:id/publish
  def publish
    @grant_award.published!
    redirect_to @grant_award, notice: "#{@grant_award.category.capitalize} published successfully."
  end

  # PATCH /grant_awards/:id/schedule
  def schedule
    scheduled_at = params[:scheduled_at]

    if scheduled_at.blank?
      redirect_to @grant_award, alert: "Please choose a date and time to schedule."
      return
    end

    parsed_time = Time.zone.parse(scheduled_at)

    if parsed_time.nil? || parsed_time <= Time.current
      redirect_to @grant_award, alert: "Scheduled time must be in the future."
      return
    end

    @grant_award.update!(status: :scheduled, scheduled_at: parsed_time)
    redirect_to @grant_award, notice: "Scheduled for #{parsed_time.strftime("%d %b %Y at %H:%M")}."
  end

  # PATCH /grant_awards/:id/cancel_schedule
  def cancel_schedule
    @grant_award.update!(status: :draft, scheduled_at: nil)
    redirect_to @grant_award, notice: "Schedule cancelled. Reverted to draft."
  end

  private

  def set_grant_award
    @grant_award = GrantAward.friendly.find(params[:id])
  end

  def grant_award_params
    params.expect(grant_award: [ :title, :description, :card_summary, :year, :awarding_body, :category, :slug, :featured ])
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
    base = action == :created ? "Entry saved" : "Entry updated"

    case status
    when :published then "#{base} and published."
    when :scheduled then "#{base} and scheduled for #{scheduled_at.strftime("%d %b %Y at %H:%M")}."
    else                 "#{base} as draft."
    end
  end
end
