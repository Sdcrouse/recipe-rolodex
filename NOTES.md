This may help with my problem below: https://stackoverflow.com/questions/4381154/rails-migration-for-has-and-belongs-to-many-join-table/4381282#4381282

My troubles with my new models:

**What works:**
```
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
```

**What does *not* work:**
```
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
```

**The mustard has egg_salad in its recipes, but the egg_salad does NOT have mustard in its ingredients.**

**I also tried making a recipe, building an ingredient into it, saving the recipe, and adding the recipe to the ingredient's recipes (because up until then, the recipe was NOT there). However, that creates two distinct RecipeIngredient objects; I only want ONE.**

So, this works: creating a recipe (my_recipe), creating an ingredient (ingred1), and creating a recipe_ingredient (with an amount) that associates my_recipe with ingred1.
However, when I then create a second ingredient (ingred2), then create a recipe_ingredient that associates ingred2 with the original recipe (my_recipe), ingred2's recipes include my_recipe, BUT my_recipe's ingredients only have ingred1, and NOT ingred2.

This is one complex set of parent-child relationships: The Recipe and Ingredient are parents, and the RecipeIngredient is the child, which is probably what's causing (a) problem.

**UPDATE:** This was solved by creating a recipe, then calling `recipe.ingredients.create(name: "New Ingredient")`. The ingredient and recipe are now correctly associated with each other.

**Now that the RecipeIngredient model has an ingredient_amount, I can't access it with an Ingredient instance OR a Recipe instance. I have to access the RecipeIngredient instance itself.**

**I have to pay close attention to how this affects one's ability to CRUD recipes and ingredients, especially with the RecipeIngredient model.**

I am creating a recipe AND its ingredients in one form, so the params hash should look like this:
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
**Further update:** I'll just use the validations on the username; I don't think a #slug method is needed as I can just use the username in the URL.

There may be some redundancy with the validation for the User's e-mail and username, since that is also checked in the signup form itself before submission.

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

```
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
```

Test code:

```
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
```

(After clearing Recipe.all, Ingredient.all, and RecipeIngredient.all):

```
>> pbj = Recipe.create(name: "Peanut Butter and Jelly Sandwich")
>> jelly = pbj.ingredients.create(name: "Jelly")

>> pbj.recipe_ingredients.last.ingredient_amount = "1 tbsp"
>> pbj.save

>> pbj.recipe_ingredients
=> #<ActiveRecord::Associations::CollectionProxy [#<RecipeIngredient id: 23, recipe_id: 77, ingredient_id: 253, ingredient_amount: nil>]>
```

**UPDATE: Here is what works:**

```
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
```

Here's why (I think) #update didn't work as expected when used on RecipeIngredient.last: RecipeIngredient instances are children of Recipe and Ingredient instances. If you update the parent, you update the child (and other parents, evidently). BUT if you update the child (as you would with RecipeIngredient.last.update), you do NOT update the parent!

One thing I still don't understand is why
```
>> pbj.recipe_ingredients.last.ingredient_amount = "1 tbsp"
>> pbj.save
```
didn't seem to work. But I can explore that later.

Update: I tried this code later:
```
steven = User.find_by(username: "scrouse")
pbj = Recipe.create(name: "Peanut Butter and Jelly Sandwich", user: steven)
jelly = pbj.ingredients.create(name: "Jelly")
pbj.recipe_ingredients.last.ingredient_amount = "1 tbsp"
pbj.save
pbj.ingredients.create(name: "Peanut Butter")
```
Which produced this output:

```
[1] pry(#<RecipesController>)> @recipe
=> #<Recipe:0x00007fffe677d920
=> #<Recipe:0x00007fffe677d920
=> #<Recipe:0x00007fffe677d920
 id: 81,
 name: "Peanut Butter and Jelly Sandwich",
 image_url: nil,
 serving_size: nil,
 servings: nil,
 additional_ingredients: nil,
 instructions: nil,
 user_id: 49,
 created_at: 2019-09-13 21:48:58 UTC,
 updated_at: 2019-09-13 21:48:58 UTC,
 description: nil,
 notes: nil>
[2] pry(#<RecipesController>)> @recipe.ingredients
D, [2019-09-13T14:50:58.412699 #231] DEBUG -- :   Ingredient Load (0.6ms)  SELECT "ingredients".* FROM "ingredients" INNER JOIN "recipe_ingredients" ON "ingredients"."id" = "recipe_ingredients"."ingredient_id" WHERE "recipe_ingredients"."recipe_id" = ?  [["recipe_id", 81]]
=> [#<Ingredient:0x00007fffe7ed6b08 id: 259, name: "Jelly">,
 #<Ingredient:0x00007fffe7ed69c8 id: 260, name: "Peanut Butter">]
[3] pry(#<RecipesController>)> @recipe.ingredients.first
=> #<Ingredient:0x00007fffe7ed6b08 id: 259, name: "Jelly">
[4] pry(#<RecipesController>)> @recipe.ingredients.first.recipe
NoMethodError: undefined method `recipe' for #<Ingredient id: 259, name: "Jelly">
Did you mean?  recipes
               recipes=
from /home/stevendc/.rvm/gems/ruby-2.6.1/gems/activemodel-4.2.11.1/lib/active_model/attribute_methods.rb:433:in `method_missing'
[5] pry(#<RecipesController>)> @recipe.ingredients.first.recipes
D, [2019-09-13T14:51:11.152266 #231] DEBUG -- :   Recipe Load (0.4ms)  SELECT "recipes".* FROM "recipes" INNER JOIN "recipe_ingredients" ON "recipes"."id" = "recipe_ingredients"."recipe_id" WHERE "recipe_ingredients"."ingredient_id" = ?  [["ingredient_id", 259]]
=> [#<Recipe:0x00007fffe7fbfe20
  id: 81,
  name: "Peanut Butter and Jelly Sandwich",
  image_url: nil,
  serving_size: nil,
  servings: nil,
  additional_ingredients: nil,
  instructions: nil,
  user_id: 49,
  created_at: 2019-09-13 21:48:58 UTC,
  updated_at: 2019-09-13 21:48:58 UTC,
  description: nil,
  notes: nil>]
[6] pry(#<RecipesController>)> @recipe.ingredients.second
=> #<Ingredient:0x00007fffe7ed69c8 id: 260, name: "Peanut Butter">
[7] pry(#<RecipesController>)> @recipe.ingredients.second.recipes
D, [2019-09-13T14:51:23.347466 #231] DEBUG -- :   Recipe Load (0.3ms)  SELECT "recipes".* FROM "recipes" INNER JOIN "recipe_ingredients" ON "recipes"."id" = "recipe_ingredients"."recipe_id" WHERE "recipe_ingredients"."ingredient_id" = ?  [["ingredient_id", 260]]
=> [#<Recipe:0x00007fffe804f138
  id: 81,
  name: "Peanut Butter and Jelly Sandwich",
  image_url: nil,
  serving_size: nil,
  servings: nil,
  additional_ingredients: nil,
  instructions: nil,
  user_id: 49,
  created_at: 2019-09-13 21:48:58 UTC,
  updated_at: 2019-09-13 21:48:58 UTC,
  description: nil,
  notes: nil>]
[8] pry(#<RecipesController>)> @recipe.recipe_ingredients
D, [2019-09-13T14:51:36.137122 #231] DEBUG -- :   RecipeIngredient Load (0.4ms)  SELECT "recipe_ingredients".* FROM "recipe_ingredients" WHERE "recipe_ingredients"."recipe_id" = ?  [["recipe_id", 81]]
=> [#<RecipeIngredient:0x00007fffe80e2ed8 id: 29, recipe_id: 81, ingredient_id: 259, ingredient_amount: nil>,
 #<RecipeIngredient:0x00007fffe80e2d98 id: 30, recipe_id: 81, ingredient_id: 260, ingredient_amount: nil>]
[9] pry(#<RecipesController>)> @recipe.ingredients.first.recipe_ingredients
D, [2019-09-13T14:52:10.830166 #231] DEBUG -- :   RecipeIngredient Load (0.4ms)  SELECT "recipe_ingredients".* FROM "recipe_ingredients" WHERE "recipe_ingredients"."ingredient_id" = ?  [["ingredient_id", 259]]
=> [#<RecipeIngredient:0x00007fffe8151f40 id: 29, recipe_id: 81, ingredient_id: 259, ingredient_amount: nil>]
[10] pry(#<RecipesController>)> RecipeIngredient.all
D, [2019-09-13T14:52:17.775915 #231] DEBUG -- :   RecipeIngredient Load (0.5ms)  SELECT "recipe_ingredients".* FROM "recipe_ingredients"
=> [#<RecipeIngredient:0x00007fffe8184350 id: 29, recipe_id: 81, ingredient_id: 259, ingredient_amount: nil>,
 #<RecipeIngredient:0x00007fffe8184210 id: 30, recipe_id: 81, ingredient_id: 260, ingredient_amount: nil>]
[11] pry(#<RecipesController>)> RecipeIngredient.last.update(ingredient_amount: "2 tbsp")
D, [2019-09-13T14:53:18.815007 #231] DEBUG -- :   RecipeIngredient Load (0.4ms)  SELECT  "recipe_ingredients".* FROM "recipe_ingredients"  ORDER BY "recipe_ingredients"."id" DESC LIMIT 1
D, [2019-09-13T14:53:18.835288 #231] DEBUG -- :    (0.1ms)  begin transaction
D, [2019-09-13T14:53:18.845302 #231] DEBUG -- :   SQL (2.5ms)  UPDATE "recipe_ingredients" SET "ingredient_amount" = ? WHERE "recipe_ingredients"."id" = ?  [["ingredient_amount", "2 tbsp"], ["id", 30]]
D, [2019-09-13T14:53:18.851126 #231] DEBUG -- :    (4.1ms)  commit transaction
=> true
[12] pry(#<RecipesController>)> RecipeIngredient.all
D, [2019-09-13T14:53:22.985570 #231] DEBUG -- :   RecipeIngredient Load (0.4ms)  SELECT "recipe_ingredients".* FROM "recipe_ingredients"
=> [#<RecipeIngredient:0x00007fffe8229738 id: 29, recipe_id: 81, ingredient_id: 259, ingredient_amount: nil>,
 #<RecipeIngredient:0x00007fffe82295f8 id: 30, recipe_id: 81, ingredient_id: 260, ingredient_amount: "2 tbsp">]
[13] pry(#<RecipesController>)> @recipe.ingredients.first.recipe_ingredients
=> [#<RecipeIngredient:0x00007fffe8151f40 id: 29, recipe_id: 81, ingredient_id: 259, ingredient_amount: nil>]
[14] pry(#<RecipesController>)> @recipe.ingredients.last.recipe_ingredients
D, [2019-09-13T14:53:41.588628 #231] DEBUG -- :   RecipeIngredient Load (0.3ms)  SELECT "recipe_ingredients".* FROM "recipe_ingredients" WHERE "recipe_ingredients"."ingredient_id" = ?  [["ingredient_id", 260]]
=> [#<RecipeIngredient:0x00007fffe82b52b0 id: 30, recipe_id: 81, ingredient_id: 260, ingredient_amount: "2 tbsp">]      
[15] pry(#<RecipesController>)> @recipe.recipe_ingredients
=> [#<RecipeIngredient:0x00007fffe80e2ed8 id: 29, recipe_id: 81, ingredient_id: 259, ingredient_amount: nil>,
 #<RecipeIngredient:0x00007fffe80e2d98 id: 30, recipe_id: 81, ingredient_id: 260, ingredient_amount: nil>]
[16] pry(#<RecipesController>)> @recipe.recipe_ingredients.first
=> #<RecipeIngredient:0x00007fffe80e2ed8 id: 29, recipe_id: 81, ingredient_id: 259, ingredient_amount: nil>
[17] pry(#<RecipesController>)> @recipe.recipe_ingredients.first.update(ingredient_amount: "1.5 tbsp")
D, [2019-09-13T14:54:50.311835 #231] DEBUG -- :    (0.1ms)  begin transaction
D, [2019-09-13T14:54:50.325948 #231] DEBUG -- :   SQL (2.7ms)  UPDATE "recipe_ingredients" SET "ingredient_amount" = ? WHERE "recipe_ingredients"."id" = ?  [["ingredient_amount", "1.5 tbsp"], ["id", 29]]
D, [2019-09-13T14:54:50.331340 #231] DEBUG -- :    (3.7ms)  commit transaction
=> true
[18] pry(#<RecipesController>)> RecipeIngredient.all
D, [2019-09-13T14:54:55.895553 #231] DEBUG -- :   RecipeIngredient Load (0.3ms)  SELECT "recipe_ingredients".* FROM "recipe_ingredients"
=> [#<RecipeIngredient:0x00007fffe7539578 id: 29, recipe_id: 81, ingredient_id: 259, ingredient_amount: "1.5 tbsp">,    
 #<RecipeIngredient:0x00007fffe7539280 id: 30, recipe_id: 81, ingredient_id: 260, ingredient_amount: "2 tbsp">]
[19] pry(#<RecipesController>)> @recipe.recipe_ingredients.first
=> #<RecipeIngredient:0x00007fffe80e2ed8 id: 29, recipe_id: 81, ingredient_id: 259, ingredient_amount: "1.5 tbsp">
[20] pry(#<RecipesController>)> @recipe.ingredients.first.recipe_ingredients
=> [#<RecipeIngredient:0x00007fffe8151f40 id: 29, recipe_id: 81, ingredient_id: 259, ingredient_amount: nil>]
```

I'll check this out later. Somehow, at one point when I updated @recipe.recipe_ingredients, it updated the Recipe and RecipeIngredient objects, but NOT the Ingredient object.

Sometimes, even though the recipe isn't in the ingredient's recipes, the recipe's recipe_ingredient is among the ingredient's recipe_ingredients.

Here, though, the recipe's recipe_ingredients got updated, but ingred's did not:
```recipe.recipe_ingredients.last.update(ingredient_amount: ingredient[:amount], brand_name: ingredient[:brand_name].capitalize)```
I'm getting inconsistent results. Sometimes, the ingredient DOES get updated, but without the recipe being added to its recipes.

**Further update:** When I just tried to update an (already existing) ingredient_amount on the recipe, it updated the recipe and the corresponding RecipeIngredient object, but not the ingredient.

So, somehow, when I call #update on @recipe.recipe_ingredients.last (or first) the first time with a new ingredient_amount, it works  (since the ingredient_amount is nil): it updates the recipe, ingredient, and the corresponding RecipeIngredient object.
But as soon as I #update it again, it updates the recipe and the RecipeIngredient object, but NOT the ingredient!

**I wonder, though: Would this problem happen again in a similar model structure? Say, with Student, Class, and Teacher?**
In this case, the teacher would have many students through classes, a student would have many teachers through classes, and a class would belong to a student and a teacher. 
However, the class would have its own attributes: location, start and end times, etc.
Would I encounter the same bug? If a class location hasn't been determined yet, then teacher.class.update(location: "Room 101") would work (it would update the teacher, class, AND student).
**But would I encounter this bug: teacher.class.update(location: "Room 203") (when its value was "Room 101") updates the teacher and class, but NOT the student?**

**FINAL UPDATE FOR ABOVE:** This problem may only be with Tux, or it's an ActiveRecord fluke; it seems to work fine in Pry, when used from the recipes/show.erb file. **But watch for this down the line, especially in the PATCH requests.**
Further update: even in Pry from the POST route, I'm having the same issue with #update. 
For now, I will just access the recipe_ingredients with "@recipe.recipe_ingredients" (not @ingredient.recipe_ingredients).
**ABSOLUTE FINAL UPDATE!!!** *I've been overthinking this.* Accessing an ingredient's recipes is beyond the scope of this project. If I want to get an ingredient's recipes later on, I should do something like this:
```
ingredient.recipe_ingredients.collect do |r_i|
  r_i.recipe
end
```

**Old code/comments for the RecipeController's "post '/recipes'" route:**
```
# This apparently works (for the first ingredient):
    # recipe = Recipe.new(params[:recipe])
    # ingred = Ingredient.create(name: params[:ingredients].first[:name])
    # recipe.ingredients << ingred
    # recipe.save

    # This works for the second ingredient and beyond:
    # ingred2 = Ingredient.create(name: params[:ingredients].second[:name])
    # recipe.ingredients << ingred2
    # recipe.recipe_ingredients.last.update(ingredient_amount: params[:ingredients].second[:amount], brand_name: params[:ingredients].second[:brand_name]")
```

**Alternative code for recipes/show.erb. Should I use this or the code I have now?**
```
<% unless @recipe.recipe_ingredients.empty? %>
  <h3>Ingredients:</h3>
  <ul>
    <!-- <%# @recipe.ingredients.each do |ingredient| %> -->
    <% @recipe.recipe_ingredients.each do |recip_ingred| %>
      <li>
        <%= recip_ingred.ingredient_amount if recip_ingred.ingredient_amount %> 
        <%= recip_ingred.ingredient.name if recip_ingred.ingredient && recip_ingred.ingredient.name %>
        <!-- Is this even needed? There should be an ingredient if recipe_ingredients is not empty. -->
      </li>
    <% end %> <!-- end of @recipe.recipe_ingredients iterator -->
    <% if @recipe.additional_ingredients %>
      <% @recipe.additional_ingredients.split(", ").each do |ingredient| %>
        <li><%= ingredient %></li>
      <% end %>
    <% end %> <!-- end of @recipe.additional_ingredients iterator -->
  </ul>
  <!-- I should have an error message here. @recipe.recipe_ingredients should NEVER be empty, even if the user specifies additional_ingredients. -->
<% end %> <!-- End of #unless -->
```

Is there a way to prevent users from filling out the "Additional Ingredients" field before filling out the first five Ingredient fields? Is that even a good idea, even if it were possible?

Give the user an option of what information to display to the public (a boolean in the users table).
Button or checkbox: Display this attribute (put in User profile form). **Add this later.**

**From the "new recipe" form, just in case I need it again:** ```<!-- <input type="text" id="ingredient_<%#= num %>_name" name="ingredients[][name]" <%#= "required" if num == 1 %> />-->```

Use #new_record? to check whether an object is a new record (i.e. hasn't been saved yet)
Use #persisted? to check whether an object has been saved AND not destroyed.

**Old (important) comments from the "new recipe" form:**
```
# Here's what I really want:
  # To make a new recipe with the given params.
  # To make new (unsaved) ingredients, or find them from the database.
  # To add the (unsaved or found from database) ingredients to the recipe.
  # To save the recipe, unless any ingredient and/or recipe validations fail.
    # Exception: It's fine if not every ingredient field is filled in, but it should NOT be saved unless it's valid.
  # To update the recipe's recipe_ingredients with any specified ingredient_amounts and brand_names.
    # (I may want to convert blank values to nil with #presence).
  # To add the recipe to the user, unless the recipe is invalid.
  # To redirect to the new recipe's page (with a success message) if the recipe is created correctly.
  # To redirect back to the "New Recipe" page with the appropriate error messages if a validation fails.
    # Don't redirect until the end, after I try to add the recipe to the user. I want to display ALL error messages.

# Here's what I don't want:
  # Recipes to be saved unless they have at least one valid ingredient, a name, and instructions.
  # Ingredients to be saved unless they have a name. Any ingredients with ingredient_amounts and/or brand_names but no names should NOT be saved.

# The recipe should have at least ONE ingredient.
# The recipe should also have a name and instructions; redirect with an error message (without saving the recipe) if it lacks either one.
# If successful, use this flash message: "You have successfully created a new recipe!"
```

**IMPORTANT!!!** Check out the notes in the Recipe model! Also, the next step is to re-write and re-seed the database, then remove the bindings in the RecipeController's POST route and test it again.

**If I give users the option of destroying their profiles, then their recipes should ALSO be destroyed. So, add this to the User model: has_many :recipes, dependent: :destroy**

**What I ought to do (to avoid confusion) is to display the right errors in the right places.**

**For future reference, use #find_or_initialize_by on the Ingredient model, not recipe.ingredients.**
Then, add that ingredient (<<) to recipe.ingredients. 
Otherwise, #find_or_initialize_by will search through recipe.ingredients (through the recipe_ingredients JOIN table) for an existing ingredient that belongs to the recipe. 
We want to search the ingredients table instead.

Instead of changing flash[:errors] to account for ActiveRecord validations, I could just add flash[:validations] and change flash[:errors] to flash[:error].

**Note: I'm getting some strange flash message bugs when I log in and out, but I don't yet know how to recreate them.**
E.g. somehow, when I entered a valid recipe URL, it took me to that page, even though I was logged out (or so I thought). Other times, the wrong flash message showed up.

**Old code from the recipes/show.erb page (before validations and flash messages):**
```
<% if @recipe && @recipe.user && !@recipe.user.username.blank? && !@recipe.name.blank? && !@recipe.ingredients.empty? && !@recipe.instructions.blank? %> 
<!-- It may be better if that ^^^ were changed to a flash message. -->

<h3>Ingredients:</h3>
<ul>
  <% @recipe.ingredients.each do |ingredient| %>
    <% unless ingredient.name.blank? %>
      <li>
        <!-- I am pretty sure that this syntax avoids multiple database queries: -->
        <!-- There may be another way to do this, but I do not (yet) know what it is. -->
        <!-- recip_ingred = RecipeIngredient.find_by(recipe: @recipe, ingredient: ingredient) -->

        <% recip_ingred = @recipe_ingredients.detect {|recip_ingred| recip_ingred.ingredient == ingredient} %>
        <% if recip_ingred %>
          <%= recip_ingred.ingredient_amount unless recip_ingred.ingredient_amount.blank? %>
          <%= recip_ingred.brand_name unless recip_ingred.brand_name.blank? %>
        <% end %>

        <%= ingredient.name %>
      </li>
    <% end %> <!-- end of "unless ingredient.name.blank?" -->
  <% end %> <!-- end of @recipe.ingredients iterator -->
</ul>
<br />

<% else %> <!-- This is connected with "if @recipe && !@recipe.ingredients.empty? &&..." at the top. -->
  <!-- It might be better to use flash messages here. -->

  <% if !@recipe %>
    <h3>Uh-Oh! This recipe doesn't exist.</h3>
  <% elsif @recipe.name.blank? %>
    <h3>Whoops! Whoever wrote this recipe forgot to give it a name!</h3>
  <% elsif !@recipe.user %> <!-- Edge case -->
    <h3>This recipe doesn't have a user. But, then, who wrote it?</h3>
  <% elsif @recipe.user.username.blank? %> <!-- Edge case -->
    <h3>This recipe's user didn't give him/herself a name for some reason!</h3>
  <% elsif @recipe.ingredients.empty? %> 
    <!-- @recipe.ingredients should not be empty, even if the user specifies additional_ingredients. -->
    <h3>What a shame! This recipe doesn't appear to have any ingredients.</h3>
  <% elsif @recipe.instructions.blank? %>
    <h3>Well, this isn't good! This recipe doesn't have instructions.</h3>
  <% end %> <!-- end of if/elsif statements starting with "if !@recipe" -->
  <p>Click <a href="/recipes">here</a> to go back to the recipes.</p>
<% end %> <!-- end of "if @recipe && !recipe.ingredients.empty &&..." -->
```
**End of old code from recipes/show.erb page**

**Old comments and ideas from the "patch '/recipes/:id'" route:**
Right now:
When creating a recipe, neither it nor its ingredients will be saved until the recipe is added to the user.
The validations:
  None for the RecipeIngredient or Ingredient models
  The Recipe validates name, instructions, having at least one ingredient (edge case), and having ingredients with names and brands and/or amounts
Blank ingredients (ingredients with no name, amount, or brand) are not saved, but they are not invalid either.
The Ingredient model has a name; the RecipeIngredient model has an ingredient_amount and a brand_name.

What I want to do:
Update the recipe, but only under these edge cases:
  The user is logged in (CHECK!), and the user is the one who wrote the recipe (CHECK!).
Save the recipe, but only if it has valid attributes (CHECK!), ingredients (CHECK!), and recipe_ingredients (CHECK!).
Avoid saving ingredients and recipe_ingredients unless the ENTIRE recipe is valid.(CHECK!)
Avoid saving ingredients that don't have names (but without triggering validation errors). (CHECK!)
Avoid saving recipe_ingredients unless their corresponding ingredient has a name. (CHECK!)
  Trigger validation errors if the recipe_ingredients have brand_names and/or ingredient_amounts, but their ingredient has no name. (CHECK!)
Create new, valid ingredients before saving the recipe (CHECK!).

How do I do this? (Note: I already figured out one edge case, and how to update a recipe with everything except the ingredients and recipe_ingredients.)
First, figure out how to update a recipe's ingredients, but without saving them. (CHECK!)
REMEMBER: If I update/save the ingredient and/or recipe_ingredient and/or recipe too early, then I will have to undo those changes if I encounter a validation error.
**End of old comments and ideas from the "patch '/recipes/:id'" route:**

**Flash messages:**
  flash[:error] = "You must be logged in to view the recipes."
  flash[:error] = "Sorry, chef! You must be logged in before you can create a new recipe."
  flash[:error] = "Congratulations, chef! You just found a bug in the Recipe Rolodex! Either you somehow got this far without being logged in, or you got logged out while creating a recipe."
  flash[:error] = "You must be logged in before you can view this recipe."
  flash[:error] = "Sorry, chef! That recipe doesn't exist."
  flash[:error] = "Sorry, Chef #{current_user.username}! The recipe that you are trying to edit does not exist."
  flash[:error] = "Sorry, Chef #{current_user.username}! You are not authorized to edit this recipe."
  flash[:error] = "Sorry, Chef! You must be logged in to edit this recipe."
  flash[:error] = "Congratulations, chef! You just found a bug in the Recipe Rolodex! Either you somehow got this far without being logged in, or you got logged out while editing a recipe."
  flash[:error] = "Congratulations, chef! You just found a bug in the Recipe Rolodex! You should not have gotten this far, since you are not authorized to edit this recipe."
  flash[:error] = "An ingredient needs a name when it's given an amount and/or brand"
  flash[:error] = "You must be logged in to delete this recipe."
  flash[:error] = "This recipe does not exist."
  flash[:error] = "Sorry, Chef #{current_user.username}! You are not authorized to delete this recipe."
  flash[:error] = "This chef does not exist."
  flash[:error] = "Invalid password. Try again."
  flash[:error] = "You must be logged in to see this chef's profile."
  flash[:error] = "It looks like this chef does not exist."
  flash[:error] = "You don't need to sign up, Chef #{current_user.username}. You're already logged in!"
  flash[:error] = "Silly chef, you're ALREADY logged in!"
  flash[:error] = "Sorry, chef! You can't log out unless you're logged in."

  flash[:validations] = recipe.errors.full_messages
  flash[:validations] = new_user.errors.full_messages

  flash[:login] = "You are not logged in."
  flash[:login] = "You are logged in."

  flash[:success] = "You have successfully logged in!"
  flash[:success] = "You have successfully signed up!"
  flash[:success] = "You have successfully logged out!"
  flash[:success] = "You have successfully edited the recipe!"
  flash[:success] = "You have successfully deleted the recipe!"


**Other images I can use:**
https://www.dreamstime.com/colori-public-domain-image-free-99545753
https://www.dreamstime.com/dish-food-cuisine-vegetarian-public-domain-image-free-93563240
https://www.dreamstime.com/lemon-orange-stock-photography-image-free-2297242
https://www.dreamstime.com/spices-prepare-tasty-food-stock-images-image-free-2848944
https://www.dreamstime.com/high-angle-view-fruit-bowl-table-public-domain-image-free-84911861
https://www.dreamstime.com/sliced-lemon-blue-chopping-board-public-domain-image-free-112809490
https://www.dreamstime.com/fresh-garden-vegetables-stock-images-image-free-6361024
https://www.dreamstime.com/pasta-ingredients-free-stock-photography-image-free-5232637

https://www.dreamstime.com/strawberry-duet-2-stock-photos-image-free-86213 **(Third choice)**
https://www.dreamstime.com/abstract-background-blueberries-close-up-public-domain-image-free-101659754 **(This one ^^^ came as a close second. The corresponding CSS is shown below.)**
```
body {
    background-image: url("../images/dreamstime_blueberries_background.jpg"); /* You'll have to rename the image. */
    background-color: rgb(79, 114, 162);
    background-size: 100% 100%;
    color: rgb(51, 51, 51);
    font-family: sans-serif;
    line-height: 18px;
    display: flex;
    align-items: center;
    background-repeat: no-repeat;
}

.wrapper {
    -moz-box-shadow: 0 0 10px rgba(0,0,0,.3);
    -webkit-box-shadow: 0 0 10px rgba(0,0,0,.3);
    max-width: 960px;
    width: 85%;
    background: rgb(255, 255, 255);
    margin: 16px 0px 16px 30%;
    padding: 2.25%;
}

```

The winner (from the choices above): https://www.dreamstime.com/raw-vegetables-free-stock-photography-image-free-18675657

**Better yet, try these guys: https://www.pexels.com/search/food/**
This is a good contender: https://www.pexels.com/photo/basil-delicious-food-ingredients-459469/
Corresponding CSS:
```
body {
    background-image: url(../images/pexels_delicious_food_ingredients.jpg);
    background-color: darkred;
    background-size: 100% 100%;
    background-repeat: no-repeat;
    color: #333;
    font-family: Sans-Serif;
    line-height: 18px;
}

.wrapper {
    background: #fff;
    -moz-box-shadow: 0 0 10px rgba(0,0,0,.3);
    -webkit-box-shadow: 0 0 10px rgba(0,0,0,.3);
    box-shadow: 0 0 10px rgba(0,0,0,.3);
    margin: 16px auto;
    max-width: 960px;
    padding: 2.25%;
    width: 85%;
}
```

And this: https://www.pexels.com/photo/carrots-food-fresh-freshness-616404/
Corresponding CSS:
```
body {
    background-image: url("../images/carrots-food-fresh-616404.jpg");
    background-color: #f13b21;
    background-size: 100% 100%;
    background-repeat: no-repeat;
    color: #333;
    font-family: Sans-Serif;
    line-height: 18px;
    /* display: flex; */ 
    /* align-items: center; */
    /* justify-content: center; */
    /* If I uncomment some of these, some of the webpages' content gets cut off. */
  }

  .wrapper {
    background: #fff;
    -moz-box-shadow: 0 0 10px rgba(0,0,0,.3);
    -webkit-box-shadow: 0 0 10px rgba(0,0,0,.3);
    box-shadow: 0 0 10px rgba(0,0,0,.3);
    margin: 16px auto;
    max-width: 960px;
    padding: 2.25%; /* 18px / 800px */
    width: 85%;
  }
  ```

**And this (the winner; no adjustment of wrapper content needed):** https://www.pexels.com/photo/five-white-plates-with-different-kinds-of-dishes-54455/

**Important note: Sometimes, changes to CSS won't show up in Chrome, possibly after a Windows update. They will, however, show up in other browsers. To fix this, clear Chrome's cache.**
**Another solution: Do a hard refresh.**

## Stretch goals and ideas:

**Bug to fix:** It is currently possible for users to add multiple ingredients with the same name to a recipe. So, a recipe's ingredients can look like this:
```
dill weed
saffron
dill weed
dill weed
chicken
```
Sometimes this is a good thing: With different varieties of cheeses (Gouda, cheddar, Swiss, etc.), I would rather have users create one "cheese" ingredient, but add different brands/types.
I should do a couple of things: 
1. Add a type/flavor/variety attribute; brand_name doesn't make sense in this case.
2. Prevent users from adding multiple ingredients with the same name, but ONLY if the amount, brand, and type/variety are blank; I'm iffy on whether to allow multiple ingredients with the same name, but different amounts.
**End of bug to fix**

**Note:** There are other stretch goals and ideas, starting at around line 104 or so; I should move them here.
Use CSS to change the links into buttons and/or tabs.
Add a red asterisk * next to required fields, and have a red message telling users about that.
Allow users to delete their accounts.
Enable password confirmation when signing up. See https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
Change '/recipes/:id' route to '/recipes/:name/:id'.
Allow users to delete ingredients in the Edit route by leaving the amount, brand, and name blank;
in that case, I should also let the user delete the first ingredient, so I need to remove a 'required' keyword in the edit form.
If I want to run other flash messages (so that they're no longer just edge cases), I should remove all of the 'required' keywords from the forms.
Change the params hash structure so that I can make better use of the #accepts_nested_attributes_for macro.
In the "create" and "edit" routes, identify the invalid ingredients in the flash message (Ingredient 1 needs a name, Ingredient 3 needs a name, etc).
Put the New Recipe button next to the "No recipes yet" message if the user hasn't made a recipe yet.
Maybe change "Your recipes: No recipes yet" to "No recipes yet".
Make a '/users' route and a users/index.erb page.
In the "get '/users/:username'" route, redirect users to '/users' if they are logged in, but the chef doesn't exist.
Delete the development.sqlite file (and possibly test.sqlite), then run rake db:migrate. If that works (causing the database entries to be reset with the seeds alone), then add that to the README as an option. I may instead have to reset the databases in Tux.
Divide this NOTES.md file into two files (at least): NOTES.md and STRETCH_GOALS.md, and separate them into the appropriate sections (past versions, problems/solutions, etc).
Idea from the "post '/recipes'" route: convert blank values to nil with #presence.
Maybe make a separate page to display errors, similar to a 404 page.
Put each error message next to the corresponding field/value.

## Ideas from Ingredient model:
 Save this for later (I might make an Amount model with quantity and units and seed the DB)
 UNITS_LIST = {
   :us => ["cup", "cups", "fl oz", "gal", "lb", "oz", "pt", "qt", "tbsp", "tsp"],
   :si => ["g", "kg", "kL", "L", "mg", "mL"],
   :other => ["dash", "dollop", "dollops", "drop", "drops", "handful", "handfuls", "piece", "pieces", pinch", "scoop", "scoops", "slice", "slices"]
 }
 Note: When the user chooses a unit from the :other hash, that unit should have the word "of" after it n the view.
 That, or just have "of" after EVERY unit.
 def self.units_list # This should protect @@units_list and its arrays of units from unwanted changes.
   Hash.new.tap do |hash|
     UNITS_LIST.each do |unit_system, units|
       hash[unit_system] = units.freeze
     end
   end.freeze
 end
 ---------------- New Features --------------------
 I want the user to be able to write their own unit and save it into their list of units (and maybe make t available to others).
 Is it possible for any changes to @@units_list to be saved into the ingredients database?

 @@units_list = {
   :us => ["cup", "fl oz", "gal", "lb", "oz", "pt", "qt", "tbsp", "tsp"],
   :si => ["L", "g", "kL", "kg", "mL", "mg"],
   :other => ["dash", "drop", "drops", "handful", "handfuls", "piece", "pieces", "pinch"]
 }
 
 def self.units_list # This should protect @@units_list from unwanted changes.
   @@units_list.dup.freeze
 end
 
 def self.add_unit_to_list(unit) # This is intended to let users SAFELY add their own units to @units_list.
   unless already_in_list?(unit)
     units_list[:other] << unit
     units_list[:other].sort! # Sort @@units_list[:other] alphabetically after adding the unit.
   end
 end
 
 def self.already_in_list?(unit) # Is the unit in @@units_list?
   units_list.detect do |unit_system, units|
     units.include?(unit)
   end
 end
## End of ideas from Ingredient model

## Logout idea from UsersController:
Later on, I want to render a logout.erb page that confirms the user's choice to log out.
That would require a get '/users/:username/logout' route (and I would need to update therresponding <a> on the layout page).
If they say "No", then redirect them to their profile page.
This will be easier to implement (I think), once the login and logout links are only shown when the user is respectively logged out or in.

get '/users/:username/logout' do
  @user = User.find_by(name: params[:username])
  erb :"users/logout"
end

post '/users/logout' do
  flash[:success] = "You have successfully logged out!"
end
## End of logout idea from UsersController

## Ideas for additional links in the layout file:
```
<!-- <nav>
  <a>About</a> <!-- Not sure about this one.
  <a>Users</a> <!-- Not sure about this, either. It should only be shown when users are logged in.
  <a>Search Recipes</a> <!-- Again, only show this when users are logged in. This is a feature for later.
        
  <!-- It may be best to put the Recipes, Search Recipes, and New Recipe links in one drop-down list.
</nav> -->
```

## Alternative idea from the recipes/new.erb file:
```
<!-- I could do this, but then I would lose the URL validation: -->
<!-- <textarea id="image_url" name="recipe[image_url]"></textarea> -->
```