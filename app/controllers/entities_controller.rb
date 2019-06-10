class EntitiesController < ApplicationController
  before_action :set_project, only: %i[index show entites_data]
  before_action :set_entities, only: %i[index reviews_for_entity]

  def index
    @entity = Entity.find_by(name: params[:entity])
    @first_word_score = first_word_score
    @last_word_score = last_word_score
    render layout: 'tour'
  end

  def reviews_for_entity
    @reviews = Entity.reviews_for_entity
    render :layout => 'tour'
  end

  def show
    @entity = Entity.find(params[:id])
    render layout: 'tour'
  end

  def entities_data
    @datasets = SentenceEntity.joins(:entity, :sentence).reject{|sentence_entity| sentence_entity.entity.sentences.count < 7}.map { |sentence_entity| { label: sentence_entity.entity.name, data: [{x: sentence_entity.entity.sentences.count, y: sentence_entity.entity.avg_sentiment}] } }
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_entities
    @entities = Project.find(params[:project_id]).entities.group(:name).order('count_id desc').count('id')
    # returns a hash of entity list in descending order
  end

  def entities_params
    params.permit(:entity)
  end

  def first_word_score
    first_word = @entity.reviews.map{|x| [x.date, x.id] }.sort.first
    byebug
    test_re = @project.reviews.find(first_word[1]).sentences.select { |sentence| sentence.content.include? @entity.name }
    test_re[0].sentiment_score
  end

  def last_word_score
    last_word = @entity.reviews.map{|x| [x.date, x.id] }.sort.second
    Review.find(last_word[1]).sentences.first.sentiment_score
  end
end


