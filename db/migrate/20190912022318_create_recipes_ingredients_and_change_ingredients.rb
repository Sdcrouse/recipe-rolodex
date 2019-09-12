class CreateRecipesIngredientsAndChangeIngredients < ActiveRecord::Migration
  def up
    create_table :recipes_ingredients do |t|
      t.integer :recipe_id
      t.integer :ingredient_id
    end

    remove_column :ingredients, :recipe_id
  end

  def down
    add_column :ingredients, :recipe_id, :integer
    drop_table :recipes_ingredients
  end
end
