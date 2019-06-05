class ReviewsController < ApplicationController
  def reviews_by_month_of_year
    render json: Review.all.group_by_month(:date, format: "%m %Y").count
  end
end
