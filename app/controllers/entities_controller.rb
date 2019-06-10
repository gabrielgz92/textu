class EntitiesController < ApplicationController
  before_action :set_project, only: %i[show entites_data]
  before_action :set_entities, only: %i[index reviews_for_entity]

  def index
    @entity = Entity.find_by(name: params[:entity])
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
    render :layout => 'tour'
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
    @entities = Project.find(params[:project_id]).entities.group(:name).order('count_id desc').count('id')
    # returns a hash of entity list in descending order
  end

  def entities_params
    params.permit(:entity)
  end
end
