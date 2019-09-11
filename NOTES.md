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

**Make sure that any user-uploaded image shows up!**

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

I thought about writing a #slug method for usernames, but that would prove problematic - "first.last", "first&last", and "first last" would return the same slug of "first-last". I don't want that.

**I don't want the login link to be visible on the login page; that makes no sense to me.**

**For convention, I think I should change profile.erb to index.erb, since there isn't much difference between the two.**

Is there a way to add a **default route** in my ApplicationController, for when the user enters an invalid URL?

**When displaying an ordered list of recipes, I should probably override that "list-style: none;" rule in the CSS file. Look up the list-style-type property.**

Be sure to link to the users' profiles in the recipes/index.erb file.

I might alias Users as Chefs, to fit the theme of the project. 
I could also write a /users index page and call it the User Directory.

I could make a drop-down list for recipes on the Recipes link. I will need to fiddle with the HTML and CSS.
The Recipes drop-down list could have a Search feature, or list them alphabetically, or have a sub-list of users and their recipes.
