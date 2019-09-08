class AddNotesToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :notes, :string
  end
end
