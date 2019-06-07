class EntitiesController < ApplicationController
  before_action :set_project, only: %i[show entites_data]

  def index
    @entities = Project.find(params[:project_id]).entities
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
end
