class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy 
  # Destroying a recipe should destroy its recipe_ingredients ^^^, but not the associated ingredients themselves.
  has_many :ingredients, through: :recipe_ingredients
  
  validate :recipe_should_have_at_least_one_ingredient
  # Two possible error messages are generated here:
    # If the recipe has no ingredients when it's saved, then AR generates my custom error message.
    # If the recipe has an ingredient that has NOT been saved, then AR generates the message, "Ingredients is invalid", without saying why.
  
  # I have added a custom error message below, that will be generated every time the second error message above is generated.
  validate :recipe_ingredients_need_names

  validates :name, presence: true
  validates :instructions, presence: true

  def recipe_should_have_at_least_one_ingredient # Edge case, due to "new recipe" form requiring at least one ingredient with a name.
    errors.add(:recipe, "should have at least one ingredient") if self.ingredients.blank?
  end

  def recipe_ingredients_need_names
    # I don't know how to delete the default error message, so I am adding a new one.
    if self.ingredients.any?{|ingredient| ingredient.name.blank?}
      errors.add(:ingredient, "needs a name") 
    end
  end
end