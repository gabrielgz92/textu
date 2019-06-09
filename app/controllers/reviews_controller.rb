class ReviewsController < ApplicationController
  before_action :set_project, only: %i[index create reviews_by_month_of_year]

  def index
    render :layout => 'tour'
  end

  def reviews_by_month_of_year
    @reviews = @project.reviews
    render json: @reviews.group_by_month(:date, format: "%m %Y").count
  end

  def sentiment_score_averages
    render json: SentenceEntity.joins(:entity, :sentence).map { |x| [x.entity.sentences.count, x.entity.avg_sentiment] }
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
