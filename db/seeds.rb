#-------- No recipes for these guys yet -----------
User.create(username: "roadrunner", email:"vroom@acme.com", password: "meepmeep!")
User.create(username: "musicman", email: "music.meister@dc.com", password: "do-re-mi")

#-------- Gordon Ramsay's recipe(s) -----------------
ramsay = User.create(username: "gordon.ramsay", email: "gramsay@topchef.uk", password: "glasgowchef")

idiot_sandwich = Recipe.create(
  name: "Idiot Sandwich", 
  description: "My least favorite sandwich in the world", 
  serving_size: "1 sandwich", servings: "1",
  instructions: "Place raw meat between slices of bread.",
  notes: "Avoid serving this at all costs!"
)

sandwich_ingredients = [
  {amount: "2 slices of", name: "bread"},
  {amount: "1 slab of", name: "raw meat"}
]

sandwich_ingredients.each do |ingred|
  idiot_sandwich.ingredients.create(name: ingred[:name])
  idiot_sandwich.recipe_ingredients.last.update(ingredient_amount: ingred[:amount])
end

ramsay.recipes << idiot_sandwich

#----------- Bilbo's recipe(s) ----------------------
bilbo_baggins = User.create(username: "bbaggins", email: "hobbitburglar@shire.net", password: "thereandbackagain")

# Second Breakfast:
second_breakfast = Recipe.create(
  name: "Second Breakfast",
  description: "The meal every hobbit worth his weight should know how to make!",
  image_url: "https://example.com",
  instructions: "Prepare all dishes mid-morning. Serve warm at any time between breakfast and lunch."
)

sb_ingredients = [
  {amount: "one cup", name: "tea"},
  {amount: "5", name: "sausage links"},
  {amount: "3", name: "pancakes"}
]

sb_ingredients.each do |ingred|
  second_breakfast.ingredients.create(name: ingred[:name])
  second_breakfast.recipe_ingredients.last.update(ingredient_amount: ingred[:amount])
end

# Idiot Sandwich:
shire_idiot_sandwich = Recipe.create(
  name: "Idiot Sandwich",
  instructions: "Sprinkle the pipeweed on one slice of bread. Cover with the other slice. Eat it at your own risk.",
  notes: "Only a fool would make this! Pipeweed is meant to be smoked, not eaten!"
)

shire_sandwich_ingredients = [
  {amount: "2 slices", name: "Shire wheat bread"},
  {amount: "2 pinches", name: "pipeweed"}
]

shire_sandwich_ingredients.each do |ingred|
  shire_idiot_sandwich.ingredients.create(name: ingred[:name])
  shire_idiot_sandwich.recipe_ingredients.last.update(ingredient_amount: ingred[:amount])
end

bilbo_baggins.recipes << second_breakfast
bilbo_baggins.recipes << shire_idiot_sandwich
 
#-------- Egghead's recipe(s) -------------------------
egghead = User.create(username: "Egghead", email: "eggcitingvillain@scrambled.com", password: "Eggcellent!")

smokey_eggs = Recipe.create(
  name: "Smokey Scrambled Eggs",
  description: "A great kind of scrambled eggs. You get the smokey flavor of the Tabasco Sauce without the heat!",
  serving_size: "One plateful", servings: "1",
  instructions: "Beat all ingredients in a bowl with a whisk or fork, about two minutes. Place a frying pan on a stove at low to medium heat. Pour eggs into frying pan. Stir constantly for about three minutes, or until eggs begin to turn brown. Serve immediately."
)

smokey_eggs_ingredients = [
  {amount: "3", name: "eggs"},
  {amount: "A dash", name: "pepper"},
  {amount: "10-15 drops", name: "Chipotle Tabasco Sauce"},
  {amount: "A dash", name: "salt"}
]

smokey_eggs_ingredients.each do |ingred|
  smokey_eggs.ingredients.create(name: ingred[:name])
  smokey_eggs.recipe_ingredients.last.update(ingredient_amount: ingred[:amount])
end

dangerous_sandwich = Recipe.create(
  name: "Idiot Sandwich",
  description: "DO NOT MAKE THIS!!! This is an example of what not to do!",
  serving_size: "One nasty sandwich", servings: "1 (or zero, if you're wise)",
  instructions: "Put a clothespin on your nose and gloves on your hands. Crack rotten egg over one slice of bread, then cover with the other slice. Throw it out, unless you want to go to the hospital!"
)

dangerous_ingredients = [
  {amount: "1", name: "rotten egg"},
  {amount: "2 slices", name: "moldy bread"}
]

dangerous_ingredients.each do |ingred|
  dangerous_sandwich.ingredients.create(name: ingred[:name])
  dangerous_sandwich.recipe_ingredients.last.update(ingredient_amount: ingred[:amount])
end

egghead.recipes << smokey_eggs
egghead.recipes << dangerous_sandwich

#----------- Winco's Recipes ----------------------------
winco = User.create(username: "Winco Foods", email: "winningstore@winco.com", password: "groc3Rie$")

winco_ingredients_hash = {
  chicken_cacciatore: [
    {amount: "1", name: "3 lb. frying chicken"},
    {amount: "1/2 cup", name: "olive oil"},
    {amount: "2 tbs.", name: "bell pepper flakes"},
    {amount: "1/8 tsp.", name: "all spice"},
    {amount: "1/4 tsp.", name: "black pepper"}
  ],
  fun_taco_cups: [
    {amount: "1 pound", name: "ground beef"},
    {amount: "1 1/4 oz.", name: "taco seasoning"},
    {amount: "1 (10 oz.) can", name: "refrigerated buttermilk biscuits"},
    {amount: "1/2 cup", name: "shredded cheddar cheese"}
  ],
  egg_drop_soup: [
    {amount: "4 cups", name: "water"},
    {amount: "4 cubes", name: "chicken bouillon"},
    {amount: "2", name: "eggs"},
    {amount: "1 teaspoon", name: "dried parsley"},
    {amount: "1 tablespoon", name: "dried minced onion"}
  ],
  idiot_sandwich: [
    {amount: "2 slices", name: "bread"},
    {amount: "2", name: "dill pickle spears"},
    {amount: "1 large scoop", name: "chocolate ice cream"},
    {amount: "1 whole", name: "habanero pepper, quartered"}
  ]
}

winco_recipes_hash = {
  chicken_cacciatore: {
    name: "Chicken Cacciatore",
    servings: "4",
    additional_ingredients: "1/4 tsp. crushed red pepper, 1/2 cup white wine or water, 1/4 cup flour, 2 tbs. instant minced onion, 1/8 tsp. instant minced garlic, 1 tbs. season-all, 1 tsp. Italian seasoning, 3 1/2 cups tomatoes",
    instructions: "Cut chicken in pieces. Dredge with flour. Brown in oil until golden on all sides. Drain off oil. Add seasonings, tomatoes, and wine or water. Cover and simmer slowly 45 minutes, or until chicken is tender.",
    notes: "Good, but spicy. Needs rice. We used chopped bell peppers, since we couldn't find bell pepper flakes."
  },

  fun_taco_cups: {
    name: "Fun Taco Cups",
    instructions: "Brown meat; drain. Add seasoning mix; prepare as directed on package. Press biscuits onto bottoms and up sides of medium muffin pan. Fill biscuits with seasoned meat. Bake at 400°F for 15 minutes. Sprinkle with cheese. Bake an additional 2 to 3 minutes or until cheese is melted. Serve with salsa, if desired.",
    notes: "A 12 oz. can of 10 biscuits works as well. Add more cheese next time. Opinions: 'Good Food', '7 out of 10', 'Easy to eat & prepare'."
  },

  egg_drop_soup: {
    name: "Egg Drop Soup",
    additional_ingredients: "1 tablespoon cornstarch",
    instructions: "In a medium saucepan, combine water, bouillon, and parsley and onion flakes. Bring to a boil. Lightly beat eggs together. Gradually stir into soup. Remove about half a cup of the soup. Stir in cornstarch until there are no lumps, and return to the soup. Boil until soup thickens."
  },

  idiot_sandwich: {
    name: "idiot sandwich",
    description: "Disclaimer: This is NOT an official Winco Foods recipe! Apologies to Winco and its affiliated companies.",
    instructions: "Plop the chocolate ice cream on one slice of bread. Place the dill pickle spears on top of the ice cream. Place the quartered habanero on top of that. Cover with the other slice of bread. Refrigerate overnight. Serves one unfortunate victim.",
    notes: "This is (probably) edible, but we pity your tastebuds and stomach if you're brave (or crazy) enough to try it."
  }
}

winco_recipes = {
  chicken_cacciatore: Recipe.create(winco_recipes_hash[:chicken_cacciatore]),
  fun_taco_cups: Recipe.create(winco_recipes_hash[:fun_taco_cups]),
  egg_drop_soup: Recipe.create(winco_recipes_hash[:egg_drop_soup]),
  idiot_sandwich: Recipe.create(winco_recipes_hash[:idiot_sandwich])
}

# For each winco_recipe, get the ingredients_hash with the same name.
# Then add each ingredient to the recipe.
# Lastly, set the corresponding recipe_ingredient's ingredient_amount.
winco_recipes.each do |recipe_name, recipe|
  winco_ingredients_hash[recipe_name].each do |ingredient|
    recipe.ingredients.create(name: ingredient[:name])
    recipe.recipe_ingredients.last.update(ingredient_amount: ingredient[:amount])
  end
end

winco_recipes.each{|recipe_name, recipe| winco.recipes << recipe}
# Either that ^^^, or set winco.recipes = winco_recipes_array, then save winco.

#----------- Note: This can all be refactored later. ---------------------------

# This wouldn't work as it would give ALL of the recipes ALL of the ingredients!
#
# winco_recipes_array.each do |recipe|
#   winco_ingredients.each do |ingred_name, ingred_hashes|
#     ingred_hashes.each do |ingredient|
#       recipe.ingredients.create(name: ingredient[:name])
#       recipe.recipe_ingredients.last.update(ingredient_amount: ingredient[:amount])
#     end
#   end  
# end
