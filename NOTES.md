**Attributes I could add to the User model:** description, favorite_recipes (This could be displayed as links to the user's favorite recipes, with the option to "Add to Favorite Recipes" option on each recipe),...

**Attributes I could add to the Recipe model:** prep_time, description, utensils, calories_per_serving, total_calories,...

I could add **prep_notes** to the Ingredient model (chopped, diced, cut into quarters, refrigerated two hours in advance, etc). But for now, I'll just use "name",...

With all of those different ingredients and recipes out there, I might wind up including a **category** attribute (or something similar) in the Recipe and Ingredient models. Then, the user could search for a recipe by category and choose a category (for recipes AND ingredients) from a SELECT list.

**The user should be able to search for a recipe by name and/or ingredient name.**

**Refactor the seeds.rb file when there's time. See https://github.com/learn-co-curriculum/nyc-sinatra/blob/solution/db/seeds.rb Make sure that the recipes belong to the right users, and the ingredients to the right recipes.**

Later on, I want to implement the "Confirm Password" functionality. 
I would also like to make sure the user enters a valid e-mail address (i.e. does it take the form "name@somewhere.com"?)

It would also be good to let the current_user delete his/her profile and edit its information.

Remember to put a link to the user's recipes on his/her profile page. On their recipes page, have a link to go back to their profile page. And have a flash message if they don't have any recipes.