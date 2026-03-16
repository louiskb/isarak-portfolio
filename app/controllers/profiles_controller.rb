class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def purge_cv
    current_user.cv.purge_later
    redirect_to profile_path, notice: "CV removed."
  end

  def update
    if current_user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.expect(user: [ :name, :about, :avatar, :cv ])
  end
end
