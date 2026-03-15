class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service

  def edit; end

  def update
    if @service.update(service_params)
      redirect_to root_path(anchor: "service"), notice: "Service description updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_service
    @service = current_user.service || current_user.create_service(description: "")
  end

  def service_params
    params.require(:service).permit(:description)
  end
end
