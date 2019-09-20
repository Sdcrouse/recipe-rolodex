class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy 
  # Destroying a recipe should destroy its recipe_ingredients ^^^, but not the associated ingredients themselves.
  # I should test that, making sure that nothing's wonky.
  has_many :ingredients, through: :recipe_ingredients
  
  validates :servings, numericality: {only_integer: true, greater_than: 0}
  validates :name, presence: true
  validates :ingredients, presence: true # I need to test this one and view the error message. I want the recipe to have at least one ingredient.
  validates :instructions, presence: true
end