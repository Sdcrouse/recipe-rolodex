#-------- Users ----------------------------------
ramsay = User.create(username: "gordon.ramsay", email: "gramsay@topchef.uk", password: "glasgowchef")
bilbo_baggins = User.create(username: "bbaggins", email: "hobbitburglar@shire.net", password: "thereandbackagain")
egghead = User.create(username: "Egghead", email: "eggcitingvillain@scrambled.com", password: "Eggcellent!")
winco = User.create(username: "Winco Foods", email: "winningstore@winco.com", password: "groc3Rie$")

#-------- No recipes for these guys yet -----------
User.create(username: "roadrunner", email:"vroom@acme.com", password: "meepmeep!")
User.create(username: "musicman", email: "music.meister@dc.com", password: "do-re-mi")

#-------- Gordon Ramsay's recipe(s) -----------------
idiot_sandwich = Recipe.create(
  name: "Idiot Sandwich", 
  description: "My least favorite sandwich in the world", 
  serving_size: "1 sandwich", servings: "1",
  instructions: "Place raw meat between slices of bread.",
  notes: "Avoid serving this at all costs!"
)

idiot_sandwich.ingredients.create(name: "bread")
idiot_sandwich.recipe_ingredients.last.update(ingredient_amount: "2 slices of")

idiot_sandwich.ingredients.create(name: "raw meat")
idiot_sandwich.recipe_ingredients.last.update(ingredient_amount: "1 slab of")

ramsay.recipes << idiot_sandwich

#----------- Bilbo's recipe(s) ----------------------
# tea = Ingredient.create(quantity: "one", units: "cup", name: "tea")
# sausages = Ingredient.create(quantity: "5", name: "sausage links")
# pancakes = Ingredient.create(quantity: "3", name: "pancakes")
# 
# pipeweed = Ingredient.create(quantity: "2", units: "pinches", name: "pipeweed")
# shire_bread = Ingredient.create(quantity: "2", units: "slices", name: "Shire wheat bread")
# 
# second_breakfast = Recipe.create(
#   name: "Second Breakfast",
#   description: "The meal every hobbit worth his weight should know how to make!",
#   image_url: "https://example.com",
#   ingredients: [tea, sausages, pancakes],
#   instructions: "Prepare all dishes mid-morning. Serve warm at any time between breakfast and lunch."
# )
# 
# shire_idiot_sandwich = Recipe.create(
#   name: "Idiot Sandwich",
#   ingredients: [pipeweed, shire_bread],
#   instructions: "Sprinkle the pipeweed on one slice of bread. Cover with the other slice. Eat it at your own risk.",
#   notes: "Only a fool would make this! Pipeweed is meant to be smoked, not eaten!"
# )
# 
# bilbo_baggins.recipes << second_breakfast
# bilbo_baggins.recipes << shire_idiot_sandwich
# 
# #-------- Egghead's recipe(s) -------------------------
# eggs = Ingredient.create(quantity: "3", name: "eggs")
# salt = Ingredient.create(quantity: "A dash", name: "salt")
# pepper = Ingredient.create(quantity: "A dash", name: "pepper")
# chipotle_sauce = Ingredient.create(quantity: "10-15", units: "drops", name: "Chipotle Tabasco Sauce")
# 
# rotten_egg = Ingredient.create(quantity: "1", name: "rotten egg")
# moldy_bread = Ingredient.create(quantity: "2", units: "slices", name: "moldy bread")
# 
# smokey_eggs = Recipe.create(
#   name: "Smokey Scrambled Eggs",
#   description: "A great kind of scrambled eggs. You get the smokey flavor of the Tabasco Sauce without the heat!",
#   serving_size: "One plateful", servings: "1",
#   ingredients: [eggs, salt, pepper, chipotle_sauce],
#   instructions: "Beat all ingredients in a bowl with a whisk or fork, about two minutes. Place a frying pan on a stove at low to medium heat. Pour eggs into frying pan. Stir constantly for about three minutes, or until eggs begin to turn brown. Serve immediately."
# )
# 
# dangerous_sandwich = Recipe.create(
#   name: "Idiot Sandwich",
#   description: "DO NOT MAKE THIS!!! This is an example of what not to do!",
#   serving_size: "One nasty sandwich", servings: "1 (or zero, if you're wise)",
#   ingredients: [rotten_egg, moldy_bread],
#   instructions: "Put a clothespin on your nose and gloves on your hands. Crack rotten egg over one slice of bread, then cover with the other slice. Throw it out, unless you want to go to the hospital!"
# )
# 
# egghead.recipes << smokey_eggs
# egghead.recipes << dangerous_sandwich
# 
# #----------- Winco's Recipes ----------------------------
# winco_ingredients = {
#   chicken_cacciatore: [
#     {quantity: "1", name: "3 lb. frying chicken"},
#     {quantity: "1/2", units: "cup", name: "olive oil"},
#     {quantity: "2", units: "tbs.", name: "bell pepper flakes"},
#     {quantity: "1/8", units: "tsp.", name: "all spice"},
#     {quantity: "1/4", units: "tsp.", name: "black pepper"}
#   ],
#   fun_taco_cups: [
#     {quantity: "1", units: "pound", name: "ground beef"},
#     {quantity: "1 1/4", units: "oz.", name: "taco seasoning"},
#     {quantity: "1", units: "(10 oz.) can", name: "refrigerated buttermilk biscuits"},
#     {quantity: "1/2", units: "cup", name: "shredded cheddar cheese"}
#   ],
#   egg_drop_soup: [
#     {quantity: "4", units: "cups", name: "water"},
#     {quantity: "4", units: "cubes", name: "chicken bouillon"},
#     {quantity: "2", name: "eggs"},
#     {quantity: "1", units: "teaspoon", name: "dried parsley"},
#     {quantity: "1", units: "tablespoon", name: "dried minced onion"}
#   ],
#   idiot_sandwich: [
#     {quantity: "2", units: "slices", name: "bread"},
#     {quantity: "2", name: "dill pickle spears"},
#     {quantity: "1", units: "large scoop", name: "chocolate ice cream"},
#     {quantity: "1", units: "whole", name: "habanero pepper, quartered"}
#   ]
# }
# 
# winco_recipes = {
#   chicken_cacciatore: {
#     name: "Chicken Cacciatore",
#     servings: "4",
#     ingredients: winco_ingredients[:chicken_cacciatore].collect{|ingredient| Ingredient.create(ingredient)},
#     additional_ingredients: "1/4 tsp. crushed red pepper, 1/2 cup white wine or water, 1/4 cup flour, 2 tbs. instant minced onion, 1/8 tsp. instant minced garlic, 1 tbs. season-all, 1 tsp. Italian seasoning, 3 1/2 cups tomatoes",
#     instructions: "Cut chicken in pieces. Dredge with flour. Brown in oil until golden on all sides. Drain off oil. Add seasonings, tomatoes, and wine or water. Cover and simmer slowly 45 minutes, or until chicken is tender.",
#     notes: "Good, but spicy. Needs rice. We used chopped bell peppers, since we couldn't find bell pepper flakes."
#   },
# 
#   fun_taco_cups: {
#     name: "Fun Taco Cups",
#     ingredients: winco_ingredients[:fun_taco_cups].collect{|ingredient| Ingredient.create(ingredient)},
#     instructions: "Brown meat; drain. Add seasoning mix; prepare as directed on package. Press biscuits onto bottoms and up sides of medium muffin pan. Fill biscuits with seasoned meat. Bake at 400°F for 15 minutes. Sprinkle with cheese. Bake an additional 2 to 3 minutes or until cheese is melted. Serve with salsa, if desired.",
#     notes: "A 12 oz. can of 10 biscuits works as well. Add more cheese next time. Opinions: 'Good Food', '7 out of 10', 'Easy to eat & prepare'."
#   },
# 
#   egg_drop_soup: {
#     name: "Egg Drop Soup",
#     ingredients: winco_ingredients[:egg_drop_soup].collect{|ingredient| Ingredient.create(ingredient)},
#     additional_ingredients: "1 tablespoon cornstarch",
#     instructions: "In a medium saucepan, combine water, bouillon, and parsley and onion flakes. Bring to a boil. Lightly beat eggs together. Gradually stir into soup. Remove about half a cup of the soup. Stir in cornstarch until there are no lumps, and return to the soup. Boil until soup thickens."
#   },
# 
#   idiot_sandwich: {
#     name: "idiot sandwich",
#     description: "Disclaimer: This is NOT an official Winco Foods recipe! Apologies to Winco and its affiliated companies.",
#     ingredients: winco_ingredients[:idiot_sandwich].collect{|ingredient| Ingredient.create(ingredient)},
#     instructions: "Plop the chocolate ice cream on one slice of bread. Place the dill pickle spears on top of the ice cream. Place the quartered habanero on top of that. Cover with the other slice of bread. Refrigerate overnight. Serves one unfortunate victim.",
#     notes: "This is (probably) edible, but we pity your tastebuds and stomach if you're brave (or crazy) enough to try it."
#   }
# }
# 
# winco_recipes_array = winco_recipes.collect do |recipe_name, recipe_hash|
#   Recipe.create(recipe_hash)
# end
# 
# winco_recipes_array.each{|recipe| winco.recipes << recipe}
# # Either that ^^^, or set winco.recipes = winco_recipes_array, then save winco
# 