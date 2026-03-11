class ResearchItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_research_item, only: %i[ show edit update destroy ]

  # GET /research_items or /research_items.json
  def index
    @research_items = ResearchItem.all
  end

  # GET /research_items/1 or /research_items/1.json
  def show
  end

  # GET /research_items/new
  def new
    @research_item = ResearchItem.new
  end

  # GET /research_items/1/edit
  def edit
  end

  # POST /research_items or /research_items.json
  def create
    @research_item = ResearchItem.new(research_item_params)

    respond_to do |format|
      if @research_item.save
        format.html { redirect_to @research_item, notice: "Research item was successfully created." }
        format.json { render :show, status: :created, location: @research_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @research_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /research_items/1 or /research_items/1.json
  def update
    respond_to do |format|
      if @research_item.update(research_item_params)
        format.html { redirect_to @research_item, notice: "Research item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @research_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @research_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /research_items/1 or /research_items/1.json
  def destroy
    @research_item.destroy!

    respond_to do |format|
      format.html { redirect_to research_items_path, notice: "Research item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_research_item
      @research_item = ResearchItem.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def research_item_params
      params.expect(research_item: [ :title, :category, :description, :external_url, :featured, :published_at, :slug ])
    end
end
