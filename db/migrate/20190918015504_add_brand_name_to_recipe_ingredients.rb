class AddBrandNameToRecipeIngredients < ActiveRecord::Migration
  def change
    add_column :recipe_ingredients, :brand_name, :string
  end
end
