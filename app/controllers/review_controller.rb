class ReviewController < ApplicationController
  before_action :set_project, only: :create

  def create
    @review = Review.new
    @review.project = @project
  end

  def index
    @reviews = current_user.reviews
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
