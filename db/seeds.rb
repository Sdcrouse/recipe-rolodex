#-------- Users ----------------------------------
ramsay = User.create(username: "gordon.ramsay", email: "gramsay@topchef.uk", password: "glasgowchef")
bilbo_baggins = User.create(username: "bbaggins", email: "hobbitburglar@shire.net", password: "thereandbackagain")
egghead = User.create(name: "Egghead", email: "eggcitingvillain@scrambled.com", password: "Eggcellent!")
winco = User.create(name: "Winco Foods", email: "winningstore@winco.com", password: "groc3Rie$")

#-------- Gordon Ramsay's recipe(s) -----------------
sliced_bread = Ingredient.create(name: "Bread", quantity: "2", units: "slices")
raw_meat = Ingredient.create(name: "Raw Meat", quantity: "1", units: "slab")

idiot_sandwich = Recipe.create(
  name: "Idiot Sandwich", 
  description: "My least favorite sandwich in the world", 
  serving_size: "1 sandwich", servings: "1", 
  instructions: "Place raw meat between slices of bread. Avoid serving it at all costs!"
)

idiot_sandwich.ingredients << sliced_bread
idiot_sandwich.ingredients << raw_meat
ramsay.recipes << idiot_sandwich

#----------- Bilbo's recipe(s) ----------------------
tea = Ingredient.create(name: "tea", quantity: "one", units: "cup")
sausages = Ingredient.create(name: "sausage links", quantity: "5")
pancakes = Ingredient.create(name: "pancakes", quantity: "3")

second_breakfast = Recipe.create(
  name: "Second Breakfast",
  description: "The meal every hobbit worth his weight should know how to make!",
  image_url: "https://example.com",
  instructions: "Prepare all dishes mid-morning. Serve warm at any time between breakfast and lunch."
)

second_breakfast.ingredients << tea
second_breakfast.ingredients << sausages
second_breakfast.ingredients << pancakes
bilbo_baggins.recipes << second_breakfast

#-------- Egghead's recipe(s) -------------------------
eggs = Ingredient.create(name: "eggs", quantity: "3")
salt = Ingredient.create(name: "salt", quantity: "A dash")
pepper = Ingredient.create(name: "pepper", quantity: "A dash")
chipotle_sauce = Ingredient.create(name: "Chipotle Tabasco Sauce", quantity: "10-15", units: "drops")

smokey_eggs = Recipe.create(
  name: "Smokey Scrambled Eggs",
  description: "A great kind of scrambled eggs. You get the smokey flavor of the Tabasco Sauce without the heat!",
  serving_size: "One plateful", servings: "1", 
  instructions: "Beat all ingredients in a bowl with a whisk or fork, about two minutes. Place a frying pan on a stove at low to medium heat. Pour eggs into frying pan. Stir constantly for about three minutes, or until eggs begin to turn brown. Serve immediately."
)

smokey_eggs.ingredients << eggs
smokey_eggs.ingredients << salt
smokey_eggs.ingredients << pepper
smokey_eggs.ingredients << chipotle_sauce
egghead.recipes << smokey_eggs
