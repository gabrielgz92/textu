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
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_entities
    @entities = Project.find(params[:project_id]).entities
  end
end
