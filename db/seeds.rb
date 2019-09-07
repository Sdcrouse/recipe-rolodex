ramsay = User.create(username: "gordon.ramsay", email: "gramsay@topchef.uk", password: "glasgowchef")
sliced_bread = Ingredient.create(name: "Bread", quantity: "2", units: "slices")
raw_meat = Ingredient.create(name: "Raw Meat", quantity: "1", units: "slab")
idiot_sandwich = Recipe.create(name: "Idiot Sandwich", serving_size: "1 sandwich", servings: "1", 
  instructions: "Place raw meat between slices of bread. Avoid serving it at all costs!")
idiot_sandwich.ingredients << sliced_bread
idiot_sandwich.ingredients << raw_meat
ramsay.recipes << idiot_sandwich


# <Recipe id: 4, name: "Peanut Butter and Jelly Sandwich", image_url: nil, serving_size: "1 sandwich", servings: "1", 
# additional_ingredients: nil, instructions: "Spread the peanut butter over one slice of bread. ..." 
# "Spread the peanut butter over one slice of bread. Spread the jelly over the other slice of bread. Put the two pieces of bread on top of each other, with the peanut butter and jelly facing inward. Serve at once. (Optionally: Cut the sandwich in half or quarters.)"

# #<Recipe id: 5, name: "Scrambled Eggs", image_url: nil, serving_size: nil, servings: nil, additional_ingredients: nil, instructions: "Crack eggs in bowl. Lightly beat with fork or whis..."

# => #<Ingredient id: 1, name: "Peanut Butter", quantity: "1", units: "tbsp", recipe_id: 4>
# => #<Ingredient id: 2, name: "Grape Jelly", quantity: "1", units: "tbsp", recipe_id: 4>
# => #<Ingredient id: 3, name: "Bread", quantity: "2", units: "Slices", recipe_id: 4>
# => #<Ingredient id: 6, name: "eggs", quantity: "3", units: nil, recipe_id: 5>
