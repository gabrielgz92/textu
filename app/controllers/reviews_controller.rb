class ReviewsController < ApplicationController
  before_action :set_project, only: %i[index create reviews_by_month_of_year]

  def index
    @busiest_month = busiest_month
    @quietest_month = quietest_month
    render layout: 'tour'
  end

  def reviews_by_month_of_year
    @reviews = @project.reviews
    render json: @reviews.group_by_month(:date, format: "%m %Y").count
  end

  def sentiment_score_averages
    render json: SentenceEntity.joins(:entity, :sentence).map { |x| [x.entity.sentences.count, x.entity.avg_sentiment] }
  end

  private

  def busiest_month
    reviews = @project.reviews
    reviews.group_by_month(:date, format: "%m").count.sort_by { |_, v| v }.reverse.first[0].to_datetime.strftime('%B')
  end

  def quietest_month
    reviews = @project.reviews
    reviews.group_by_month(:date, format: "%m %Y").count.sort_by { |_, v| v }.reverse.last[0].to_datetime.strftime('%B')
  end

  def set_project
    @project = Project.find(params[:project_id])
  end
end
