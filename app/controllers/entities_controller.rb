class EntitiesController < ApplicationController
  before_action :set_project, only: %i[index show entites_data index]
  before_action :set_entities, only: %i[index reviews_for_entity]

  def index
    @entity = Entity.find_by(name: params[:entity])
    @first_word_score = first_word_score
    @last_word_score = last_word_score
    @first_month = first_month
    @last_month = last_month
    render layout: 'tour'
  end

  def reviews_for_entity
    @reviews = Entity.reviews_for_entity
    render layout: 'tour'
  end

  def show
    @entity = Entity.find(params[:id])
    render layout: 'tour'
  end

  def entities_data
    @datasets = SentenceEntity.joins(:entity, :sentence).reject{|sentence_entity| sentence_entity.entity.sentences.count < 7}.map { |sentence_entity| { label: sentence_entity.entity.name, data: [{x: sentence_entity.entity.sentences.count, y: sentence_entity.entity.avg_sentiment}] } }
    render layout: 'tour'
    # 1. get all the sentence entities and include entities and sentences via their relations

    sentence_entities = SentenceEntity.joins(:entity, :sentence).includes(entity: :sentences)
     # 2. reject all sentence entities where count < 7

    filtered_entities = sentence_entities.reject{ |sentence_entity| sentence_entity.entity.sentences.size < 7 }
    # 3. map the filtered data into a form that chart.js like
    @datasets = filtered_entities.map { |sentence_entity| { label: sentence_entity.entity.name, data: [{x: sentence_entity.entity.sentences.size, y: sentence_entity.entity.avg_sentiment}] } }
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_entities
    if params[:query].present?
      @entities = Project.find(params[:project_id]).entities.search_by_entity_name(params[:query]).reorder(nil).group(:name).order('count_id desc').count('id')
    else
      @entities = Project.find(params[:project_id]).entities.group(:name).order('count_id desc').count('id')
    end
    # returns a hash of entity list in descending order
  end

  def entities_params
    params.permit(:entity)
  end

  def avg_entity_symbol
    @project.sentences.pluck(:sentiment_score).reduce(&:+) / @entity.sentence_entities.count
  end

  def first_word_score
    if @entity
      first_word = @entity.reviews.map{|x| [x.date, x.id] }.sort.first
      test_re = @project.reviews.find(first_word[1]).sentences.select { |sentence| sentence.content.include? @entity.name }
      test_re[0].sentiment_score
    end
  end

  def last_word_score
    if @entity
      last_word = @entity.reviews.map{|x| [x.date, x.id] }.sort.second
      Review.find(last_word[1]).sentences.first.sentiment_score
    end
  end

  def first_month
    if @entity
      date = @entity.reviews.group_by_month(:date, format: "%m %Y").count.first[0].to_i
      Date::MONTHNAMES[date]
    end
  end

  def last_month
    if @entity
      date = @entity.reviews.group_by_month(:date, format: "%m %Y").count.sort.reverse.first[0].to_i
      Date::MONTHNAMES[date]
    end
  end
end

