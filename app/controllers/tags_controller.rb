class TagsController < ApplicationController
  before_action :authenticate_user!

  def create
    name = params.dig(:tag, :name).to_s.strip
    if name.blank?
      render json: { error: "Name can't be blank" }, status: :unprocessable_entity
      return
    end

    @tag = Tag.find_or_create_by(name: name.titleize)
    if @tag.persisted?
      render json: { id: @tag.id, name: @tag.name }, status: :ok
    else
      render json: { error: @tag.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy!
    head :no_content
  end
end
