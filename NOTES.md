This may help with my problem below: https://stackoverflow.com/questions/4381154/rails-migration-for-has-and-belongs-to-many-join-table/4381282#4381282

My troubles with my new models:

**What works:**
>> egg_salad = Recipe.new(name: "Egg Salad")
=> #<Recipe id: nil, name: "Egg Salad", image_url: nil, serving_size: nil, servings: nil, additional_ingredients: nil, instructions: nil, user_id: nil, created_at: nil, updated_at: nil, description: nil, notes: nil>

>> eggs = Ingredient.new(name: "Eggs")
=> #<Ingredient id: nil, name: "Eggs">

>> RecipeIngredient.create(recipe: egg_salad, ingredient: eggs, ingredient_amount: "2")
D, [2019-09-12T14:48:00.884526 #141] DEBUG -- :    (0.1ms)  begin transaction
D, [2019-09-12T14:48:00.892661 #141] DEBUG -- :   SQL (1.6ms)  INSERT INTO "recipes" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Egg Salad"], ["created_at", "2019-09-12 21:48:00.890390"], ["updated_at", "2019-09-12 21:48:00.890390"]]
D, [2019-09-12T14:48:00.897658 #141] DEBUG -- :   SQL (0.2ms)  INSERT INTO "ingredients" ("name") VALUES (?)  [["name", 
"Eggs"]]
D, [2019-09-12T14:48:00.899305 #141] DEBUG -- :   SQL (0.2ms)  INSERT INTO "recipe_ingredients" ("ingredient_amount", "recipe_id", "ingredient_id") VALUES (?, ?, ?)  [["ingredient_amount", "2"], ["recipe_id", 70], ["ingredient_id", 237]]   
D, [2019-09-12T14:48:00.902433 #141] DEBUG -- :    (1.8ms)  commit transaction
=> #<RecipeIngredient id: 5, recipe_id: 70, ingredient_id: 237, ingredient_amount: "2">

>> eggs.recipes
D, [2019-09-12T14:48:23.622049 #141] DEBUG -- :   Recipe Load (0.2ms)  SELECT "recipes".* FROM "recipes" INNER JOIN "recipe_ingredients" ON "recipes"."id" = "recipe_ingredients"."recipe_id" WHERE "recipe_ingredients"."ingredient_id" = ?  [["ingredient_id", 237]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Recipe id: 70, name: "Egg Salad", image_url: nil, serving_size: nil, servings: nil, additional_ingredients: nil, instructions: nil, user_id: nil, created_at: "2019-09-12 21:48:00", updated_at: "2019-09-12 21:48:00", description: nil, notes: nil>]>

>> egg_salad.ingredients
D, [2019-09-12T14:49:09.792074 #141] DEBUG -- :   Ingredient Load (0.5ms)  SELECT "ingredients".* FROM "ingredients" INNER JOIN "recipe_ingredients" ON "ingredients"."id" = "recipe_ingredients"."ingredient_id" WHERE "recipe_ingredients"."recipe_id" = ?  [["recipe_id", 70]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Ingredient id: 237, name: "Eggs">]>

>> eggs.recipes.include?(egg_salad)
=> true
>> egg_salad.ingredients.include?(eggs)
=> true

**What does *not* work:**
>> mustard = Ingredient.new(name: "mustard")
=> #<Ingredient id: nil, name: "mustard">

>> RecipeIngredient.create(recipe: egg_salad, ingredient: mustard, ingredient_amount: "2 tsp")
D, [2019-09-12T14:51:25.030980 #141] DEBUG -- :    (0.1ms)  begin transaction
D, [2019-09-12T14:51:25.035027 #141] DEBUG -- :   SQL (2.2ms)  INSERT INTO "ingredients" ("name") VALUES (?)  [["name", 
"mustard"]]
D, [2019-09-12T14:51:25.048115 #141] DEBUG -- :   SQL (0.2ms)  INSERT INTO "recipe_ingredients" ("recipe_id", "ingredient_amount", "ingredient_id") VALUES (?, ?, ?)  [["recipe_id", 70], ["ingredient_amount", "2 tsp"], ["ingredient_id", 238]]
D, [2019-09-12T14:51:25.053364 #141] DEBUG -- :    (3.1ms)  commit transaction
=> #<RecipeIngredient id: 6, recipe_id: 70, ingredient_id: 238, ingredient_amount: "2 tsp">

>> mustard.recipes
D, [2019-09-12T14:52:22.344145 #141] DEBUG -- :   Recipe Load (0.2ms)  SELECT "recipes".* FROM "recipes" INNER JOIN "recipe_ingredients" ON "recipes"."id" = "recipe_ingredients"."recipe_id" WHERE "recipe_ingredients"."ingredient_id" = ?  [["ingredient_id", 238]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Recipe id: 70, name: "Egg Salad", image_url: nil, serving_size: nil, servings: nil, additional_ingredients: nil, instructions: nil, user_id: nil, created_at: "2019-09-12 21:48:00", updated_at: "2019-09-12 21:48:00", description: nil, notes: nil>]>

>> egg_salad.ingredients
=> #<ActiveRecord::Associations::CollectionProxy [#<Ingredient id: 237, name: "Eggs">]>

>> mustard.recipes.include?(egg_salad)
=> true
>> egg_salad.ingredients.include?(mustard)
=> false

**The mustard has egg_salad in its recipes, but the egg_salad does NOT have mustard in its ingredients.**

**I also tried making a recipe, building an ingredient into it, saving the recipe, and adding the recipe to the ingredient's recipes (because up until then, the recipe was NOT there). However, that creates two distinct RecipeIngredient objects; I only want ONE.**

So, this works: creating a recipe (my_recipe), creating an ingredient (ingred1), and creating a recipe_ingredient (with an amount) that associates my_recipe with ingred1.
However, when I then create a second ingredient (ingred2), then create a recipe_ingredient that associates ingred2 with the original recipe (my_recipe), ingred2's recipes include my_recipe, BUT my_recipe's ingredients only have ingred1, and NOT ingred2.

This is one complex set of parent-child relationships: The Recipe and Ingredient are parents, and the RecipeIngredient is the child, which is probably what's causing (a) problem.



**Now that the RecipeIngredient model has an ingredient_amount, I can't access it with an Ingredient instance OR a Recipe instance. I have to access the RecipeIngredient instance itself.**

**I have to pay close attention to how this affects one's ability to CRUD recipes and ingredients, especially with the RecipeIngredient model.**

**Erase this after implementing it:** I am creating a recipe AND its ingredients in one form, so the params hash should look like this:
params = {
  :recipe => {
    name: "name1",
    image_url: "https://example.com",
    description: "This is the description",
    serving_size: "2 cups",
    servings: "4",
    additional_ingredients: "ingredient5, ingredient6, ingredient7",
    instructions: "Mix, bake, cool, and serve",
    notes: "Some random notes about the recipe",
    created_at: "The current UTC time",
    updated_at: "The current UTC time, as above. This should change when it's updated."
  },
  :ingredients: [
    {quantity: "1", units: "cup", name: "Joe"},
    {quantity: "2", units: "halved", name: "apples"},
    {quantity: "1/8", units: "tsp", name: "ingredient3"},
    {quantity: "2", units: "tbsp", name: "milk"},
    {quantity: "2", units: "dashes", name: "last ingredient (5 max.)"}
  ]
}
**Don't forget to add the recipe to the User! Also, remember that I wanted a drop-down list for each ingredient's units (see Ingredient model).**
**Update: That plan has changed.** 
The units and quantity now belong to RecipeIngredients, possibly as a separate Amount class later on. Maybe I should have the User choose a unit from a drop-down or radio list (organized by unit system).
For now, RecipeIngredients will have an "amounts" attribute that combines quantity and units.

In addition to names, Ingredients could have food groups (fruits, veggies, minerals, meat, dairy, etc.), which can be chosen through a radio or drop-down list.

Question: Do I now want to give Users many Ingredients through Recipes? (Like when showing what Ingredients a User has used, e.g.?)

**What I could also do now is make a (sorted-by-name) drop-down list of ingredient names, along with a "create your own" option.**
**This would be next to the "amount" option.**
**The "create your own" option should validate against blank values, but ONLY if selected.**
**Same thing with "amount" (sorted drop-down list AND validations).**

**Make sure that any user-uploaded image shows up!**

**Attributes I could add to the User model:** description, **favorite_recipes** (This could be displayed as links to the user's favorite recipes, with the option to "Add to Favorite Recipes" option on each recipe),...

**Attributes I could add to the Recipe model:** prep_time, description, utensils, calories_per_serving, total_calories,...

I could add **prep_notes** to the Ingredient model (chopped, diced, cut into quarters, refrigerated two hours in advance, etc). But for now, I'll just use "name",...

With all of those different ingredients and recipes out there, I might wind up including a **category** attribute (or something similar) in the Recipe and Ingredient models. Then, the user could search for a recipe by category and choose a category (for recipes AND ingredients) from a SELECT list.

**The user should be able to search for a recipe by name and/or ingredient name.**

**Refactor the seeds.rb file when there's time. See https://github.com/learn-co-curriculum/nyc-sinatra/blob/solution/db/seeds.rb Make sure that the user-recipe-recipe_ingredient-ingredient relationships are all correct.**

Later on, I want to implement the "Confirm Password" functionality. 
I would also like to make sure the user enters a valid e-mail address (i.e. does it take the form "name@somewhere.com"?)

It would also be good to let the current_user delete his/her profile and edit its information.

Remember to put a link to the user's recipes on his/her profile page. On their recipes page, have a link to go back to their profile page. And have a flash message if they don't have any recipes.

I thought about writing a #slug method for usernames, but that would prove problematic - "first.last", "first&last", and "first last" would return the same slug of "first-last". I don't want that. **Update:** That could work if I use the correct validations for usernames (i.e. no blank spaces, and "userName" and "Username" would be treated as the same username.)

**I don't want the login link to be visible on the login page; that makes no sense to me.**

**For convention, I think I should change profile.erb to index.erb, since there isn't much difference between the two.**

Is there a way to add a **default route** in my ApplicationController, for when the user enters an invalid URL?

**When displaying an ordered list of recipes, I should probably override that "list-style: none;" rule in the CSS file. Look up the list-style-type property.**

Be sure to link to the users' profiles in the recipes/index.erb file.

I might alias Users as Chefs, to fit the theme of the project. 
I could also write a /users index page and call it the User Directory.

I could make a drop-down list for recipes on the Recipes link. I will need to fiddle with the HTML and CSS.
The Recipes drop-down list could have a Search feature, or list them alphabetically, or have a sub-list of users and their recipes.

**Maybe a recipe and its ingredients should be dropped when a user is deleted; so, write a dependency.**

Maybe I should add a Name input field when creating a User. It is optional, of course, but then I'd be able to make custom messages that address the user by name (by default) instead of by username.
If they don't provide a Name, then address them by username.
Caveat: This may confuse Users: name vs. username
Maybe label the field something like "Name you want to be called by". New feature to try out later.


Example inputs and params hash:

<input type="text" name="recipe[name]"> 
<input type="text" name="ingredients[][name]">

"recipe": {

  
  "name": "value", 
}
  "ingredients": {[
    "name": "some name", honey
    "ingredient_amount" 2tbsp
  ]}
new_ingredient = pbj.cr
pbj.recipe_ingredients.last.ingredient_amount =
pbj.ingredients.create(:name => params[:ingredients][:name])



Test code:

>> pbj = Recipe.create(name: "Peanut Butter and Jelly Sandwich")
=> #<Recipe id: 76, name: "Peanut Butter and Jelly Sandwich", image_url: nil, serving_size: nil, servings: nil, additional_ingredients: nil, instructions: nil, user_id: nil, created_at: "2019-09-13 17:17:51", updated_at: "2019-09-13 17:17:51", description: nil, notes: nil>

>> jelly = pbj.ingredients.create(name: "Jelly")
=> #<Ingredient id: 251, name: "Jelly">

>> pbj.recipe_ingredients.last.ingredient_amount = "1 tbsp"
=> "1 tbsp"

>> pbj.recipe_ingredients.last.ingredient_amount
=> "1 tbsp"

>> jelly.recipe_ingredients
=> #<ActiveRecord::Associations::CollectionProxy [#<RecipeIngredient id: 21, recipe_id: 76, ingredient_id: 251, ingredient_amount: nil>]>

>> RecipeIngredient.all
=> #<ActiveRecord::Relation [#<RecipeIngredient id: 21, recipe_id: 76, ingredient_id: 251, ingredient_amount: nil>]>

>> bread = pbj.ingredients.create(name: "Bread")
=> #<Ingredient id: 252, name: "Bread">

>> RecipeIngredient.all
=> #<ActiveRecord::Relation [#<RecipeIngredient id: 21, recipe_id: 76, ingredient_id: 251, ingredient_amount: nil>, #<RecipeIngredient id: 22, recipe_id: 76, ingredient_id: 252, ingredient_amount: nil>]>

>> RecipeIngredient.last.update(ingredient_amount: "2 slices")
=> true

>> RecipeIngredient.all
=> #<ActiveRecord::Relation [#<RecipeIngredient id: 21, recipe_id: 76, ingredient_id: 251, ingredient_amount: nil>, #<RecipeIngredient id: 22, recipe_id: 76, ingredient_id: 252, ingredient_amount: "2 slices">]>

>> pbj.recipe_ingredients
=> #<ActiveRecord::Associations::CollectionProxy [#<RecipeIngredient id: 21, recipe_id: 76, ingredient_id: 251, ingredient_amount: "1 tbsp">, #<RecipeIngredient id: 22, recipe_id: 76, ingredient_id: 252, ingredient_amount: nil>]>

>> bread.recipe_ingredients
=> #<ActiveRecord::Associations::CollectionProxy [#<RecipeIngredient id: 22, recipe_id: 76, ingredient_id: 252, ingredient_amount: "2 slices">]>

(After clearing Recipe.all, Ingredient.all, and RecipeIngredient.all):

>> pbj = Recipe.create(name: "Peanut Butter and Jelly Sandwich")
>> jelly = pbj.ingredients.create(name: "Jelly")

>> pbj.recipe_ingredients.last.ingredient_amount = "1 tbsp"
>> pbj.save

>> pbj.recipe_ingredients
=> #<ActiveRecord::Associations::CollectionProxy [#<RecipeIngredient id: 23, recipe_id: 77, ingredient_id: 253, ingredient_amount: nil>]>


**UPDATE: Here is what works:**

pbj = Recipe.create(name: "Peanut Butter and Jelly Sandwich")
jelly = pbj.ingredients.create(name: "Jelly")

>> pbj.recipe_ingredients.last.update(ingredient_amount: "1 tbsp")
=> true

>> pbj.recipe_ingredients
=> #<ActiveRecord::Associations::CollectionProxy [#<RecipeIngredient id: 24, recipe_id: 78, ingredient_id: 254, ingredient_amount: "1 tbsp">]>

>> jelly.recipe_ingredients
=> #<ActiveRecord::Associations::CollectionProxy [#<RecipeIngredient id: 24, recipe_id: 78, ingredient_id: 254, ingredient_amount: "1 tbsp">]>

>> RecipeIngredient.last
=> #<RecipeIngredient id: 24, recipe_id: 78, ingredient_id: 254, ingredient_amount: "1 tbsp">

Here's why (I think) #update didn't work as expected when used on RecipeIngredient.last: RecipeIngredient instances are children of Recipe and Ingredient instances. If you update the parent, you update the child (and other parents, evidently). BUT if you update the child (as you would with RecipeIngredient.last.update), you do NOT update the parent!

One thing I still don't understand is why
```
>> pbj.recipe_ingredients.last.ingredient_amount = "1 tbsp"
>> pbj.save
```
didn't seem to work. But I can explore that later.