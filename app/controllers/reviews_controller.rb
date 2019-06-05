class ReviewsController < ApplicationController
  before_action :set_project, only: :create

  def index
    @reviews = current_user.reviews
  end

  def reviews_by_month_of_year
    render json: Review.all.group_by_month(:date, format: "%m %Y").count
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
