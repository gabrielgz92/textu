class AddProjectNameandDescriptiontoProjects < ActiveRecord::Migration[5.2]
  def change
     add_column :projects, :project_name, :string
     add_column :projects, :description, :text
  end
end
