class ChangeAmountToIngredientAmount < ActiveRecord::Migration
  def change
    rename_column :recipe_ingredients, :amount, :ingredient_amount
  end
end
