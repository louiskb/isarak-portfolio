class TeachingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_teaching, only: %i[ show edit update destroy ]

  # GET /teachings or /teachings.json
  def index
    @teachings = Teaching.all
  end

  # GET /teachings/1 or /teachings/1.json
  def show
  end

  # GET /teachings/new
  def new
    @teaching = Teaching.new
  end

  # GET /teachings/1/edit
  def edit
  end

  # POST /teachings or /teachings.json
  def create
    @teaching = Teaching.new(teaching_params)

    respond_to do |format|
      if @teaching.save
        format.html { redirect_to @teaching, notice: "Teaching was successfully created." }
        format.json { render :show, status: :created, location: @teaching }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @teaching.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachings/1 or /teachings/1.json
  def update
    respond_to do |format|
      if @teaching.update(teaching_params)
        format.html { redirect_to @teaching, notice: "Teaching was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @teaching }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @teaching.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachings/1 or /teachings/1.json
  def destroy
    @teaching.destroy!

    respond_to do |format|
      format.html { redirect_to teachings_path, notice: "Teaching was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teaching
      @teaching = Teaching.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def teaching_params
      params.expect(teaching: [ :title, :description, :institution, :year, :image_url, :slug ])
    end
end
