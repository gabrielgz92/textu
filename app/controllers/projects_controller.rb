class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    if @project.save

      redirect_to projects_path
      # just for testing, this needs to redirect to graphs later on
    else
      render :new
    end
  end

  # Important Tip
  # For reading CSV file within Project instance, use
  # project_instances.reviews_csv.file.file

  private

  def project_params
    params.require(:project).permit(:project_name, :description, :reviews_csv)
  end
end
