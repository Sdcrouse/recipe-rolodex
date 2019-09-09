class ChangeTypeOfAdditionalIngredients < ActiveRecord::Migration
  def change
    change_column :recipes, :additional_ingredients, :string
  end
end
