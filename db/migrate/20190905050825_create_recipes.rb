class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :image_url
      t.string :serving_size
      t.string :servings
      t.text :additional_ingredients
      t.text :instructions
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
