class CombineQuantityAndUnitsIntoAmount < ActiveRecord::Migration
  def up
    add_column :recipes_ingredients, :amount, :string
    remove_column :ingredients, :quantity
    remove_column :ingredients, :units
  end

  def down
    add_column :ingredients, :units, :string
    add_column :ingredients, :quantity, :string
    remove_column :recipes_ingredients, :amount
  end
end
