class ReviewsController < ApplicationController
  def reviews_by_month
    render json: Review.all.group_by_month(:date, format: "%m").count
  end
end
