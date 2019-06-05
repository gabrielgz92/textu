class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects
  end

  def new
    @projects = Project.new
  end

  def create
    @projects = Project.new(project_params)
  end

  private

  def project_params
  end
end
