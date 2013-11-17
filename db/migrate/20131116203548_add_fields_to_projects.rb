class AddFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :url_home, :string
    add_column :projects, :url_repository, :string
    add_column :projects, :url_docs, :string
    add_column :projects, :url_test, :string
    add_column :projects, :url_staging, :string
    add_column :projects, :url_production, :string
  end
end
