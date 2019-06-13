class ReviewsController < ApplicationController
  before_action :set_project, only: %i[create reviews_by_month_of_year reviews_by_month_graph]

  def index
    @project = Project.includes(:reviews, entities: [:sentence_entities, :sentences]).find(params[:project_id])

    if params[:keyword]
      entity = @project.entities.detect { |entity| entity[:name] === params[:keyword] }
      @reviews = entity.reviews
    else
      @reviews = @project.reviews
    end

    render :layout => 'tour'
  end

  def reviews_by_month_graph
    @reviews = @project.reviews
    @busiest_month = busiest_month
    @quietest_month = quietest_month
    render layout: 'tour'
  end

  def reviews_by_month_of_year
    @reviews = @project.reviews
    render json: @reviews.group_by_month(:date, format: "%m %Y").count
  end

  # def sentiment_score_averages
  #   render json: SentenceEntity.joins(:entity, :sentence).includes(entity: :sentences).map { |x| [x.entity.sentences.size, x.entity.avg_sentiment] }
  # end

  def conclusion
    render layout: 'tour'
  end

  private

  def busiest_month
    reviews = @project.reviews
    month_number = reviews.group_by_month(:date, format: "%m").count.sort_by { |_, v| v }&.reverse&.first[0]&.to_i
    Date::MONTHNAMES[month_number]
  end

  def quietest_month
    reviews = @project.reviews
    month_number = reviews.group_by_month(:date, format: "%m %Y").count.sort_by { |_, v| v }&.reverse&.last[0]&.to_i
    Date::MONTHNAMES[month_number]
  end

  def set_project
    @project = Project.find(params[:project_id])
  end
end
