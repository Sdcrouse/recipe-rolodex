class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy 
  # Destroying a recipe should destroy its recipe_ingredients ^^^, but not the associated ingredients themselves.
  has_many :ingredients, through: :recipe_ingredients
  
  validate :recipe_should_have_at_least_one_ingredient
  # Update: Two possible error messages are generated here:
    # If the recipe has no ingredients when it's saved, then AR generates my custom error message.
    # If the recipe has an ingredient that has NOT been saved, then AR generates the message, "Ingredients is invalid", without saying why.
  # To avoid getting the latter error message, I should write my custom flash message: "Ingredient's name can't be blank"
  
  validates :name, presence: true
  validates :servings, numericality: {only_integer: true, greater_than: 0}, allow_blank: true
  validates :instructions, presence: true

  def recipe_should_have_at_least_one_ingredient # Edge case, due to "new recipe" form requiring at least one ingredient with a name.
    errors.add(:recipe, "should have at least one ingredient") if self.ingredients.blank?
  end
end