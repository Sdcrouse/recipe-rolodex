class AddDescriptionToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :description, :string
  end
end
