class EntitiesController < ApplicationController
  before_action :set_project, only: %i[show entites_data]
  before_action :set_entities, only: %i[index reviews_for_entity]

  def index

  end

  def reviews_for_entity

  end

  def show
    @entity = Entity.first
  end

  def entities_data
    @datasets = SentenceEntity.joins(:entity, :sentence).reject{|sentence_entity| sentence_entity.entity.sentences.count < 7}.map { |sentence_entity| { label: sentence_entity.entity.name, data: [{x: sentence_entity.entity.sentences.count, y: sentence_entity.entity.avg_sentiment}] } }
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_entities
    @entities = Project.find(params[:project_id]).entities
  end
end
