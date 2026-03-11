class GrantAwardsController < ApplicationController
  before_action :set_grant_award, only: %i[ show edit update destroy ]

  # GET /grant_awards or /grant_awards.json
  def index
    @grant_awards = GrantAward.all
  end

  # GET /grant_awards/1 or /grant_awards/1.json
  def show
  end

  # GET /grant_awards/new
  def new
    @grant_award = GrantAward.new
  end

  # GET /grant_awards/1/edit
  def edit
  end

  # POST /grant_awards or /grant_awards.json
  def create
    @grant_award = GrantAward.new(grant_award_params)

    respond_to do |format|
      if @grant_award.save
        format.html { redirect_to @grant_award, notice: "Grant award was successfully created." }
        format.json { render :show, status: :created, location: @grant_award }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grant_award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grant_awards/1 or /grant_awards/1.json
  def update
    respond_to do |format|
      if @grant_award.update(grant_award_params)
        format.html { redirect_to @grant_award, notice: "Grant award was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @grant_award }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grant_award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grant_awards/1 or /grant_awards/1.json
  def destroy
    @grant_award.destroy!

    respond_to do |format|
      format.html { redirect_to grant_awards_path, notice: "Grant award was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grant_award
      @grant_award = GrantAward.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def grant_award_params
      params.expect(grant_award: [ :title, :description, :year, :awarding_body, :category, :slug ])
    end
end
