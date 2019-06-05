require 'csv'

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
      parse_csv_into_reviews
      # save project as reviews here when project is created

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

  def parse_csv_into_reviews
    csv_file_path = @project.reviews_csv.file.file
    csv_text = File.read(csv_file_path)
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1', row_sep: :auto, col_sep: ";")
    csv.each do |row|
      r = Review.new
      r.listing_id = row['listing_id']
      r.date = row['date']
      r.reviewer_id = row['reviewer_id']
      r.reviewer_name = row['reviewer_name']
      r.comments = row['comments']
      r.project = @project
      r.save
    end
  end
end
