class ReviewsController < ApplicationController
  before_action :set_project, only: :create

  def index
    @reviews = current_user.reviews
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
