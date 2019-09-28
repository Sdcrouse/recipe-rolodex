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
  validate :ingredients_need_names_if_amount_or_brand_are_specified

  validates :name, presence: true
  validates :instructions, presence: true

  def recipe_should_have_at_least_one_ingredient # Edge case, due to "new recipe" form requiring at least one ingredient with a name.
    errors.add(:recipe, "should have at least one ingredient") if self.ingredients.blank?
  end

  def ingredients_need_names_if_amount_or_brand_are_specified
    # I am looking for a recipe_ingredient with an amount and/or brand, but whose ingredient lacks a name.
    
    invalid_recipe_ingredient = self.recipe_ingredients.detect do |rec_ingr|
      rec_ingr.ingredient.name.blank? && (!rec_ingr.ingredient_amount.blank? || !rec_ingr.brand_name.blank?)
    end
    
    if invalid_recipe_ingredient
      errors.add(:ingredient, "needs a name when it's given an amount and/or brand")
    end
  end # End of #ingredients_need_names_if_amount_or_brand_name_are_specified
end # End of Recipe class