# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
**Sinatra is included in the Gemfile, required in the environment, and used extensively in the application, especially the controllers.**

- [x] Use ActiveRecord for storing information in a database
**ActiveRecord::Base is used in the environment to set up the database, and it is used in the db/migrate/ directory to set up the tables. The models inherit from ActiveRecord::Base and use ActiveRecord macros; some also use ActiveRecord validations.**

- [x] Include more than one model class (e.g. User, Post, Category)
**Due to the complex relationships needed in this project, there are three models (User, Recipe, and Inredient) and a JOIN model (RecipeIngredient).**

- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts)
**In this project, a User has_many Recipes. There are also four other has_many relationships:**
* Recipe has_many RecipeIngredients
* Recipe has_many Ingredients through RecipeIngredients
* Ingredient has_many RecipeIngredients
* Ingredient has_many Recipes through RecipeIngredients

- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User)
**These are the belongs_to relationships:**
* Recipe belongs_to a User
* RecipeIngredient belongs_to a Recipe and an Ingredient

- [x] Include user accounts with unique login attribute (username or email)
**The user accounts have unique usernames. They also have emails, but they are not unique.**

- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying
**The Recipe, which belongs_to a User, has all of these CRUD routes in the RecipesController. The routes are:**
1. Create routes
  * get '/recipes/new'
  * post '/recipes
2. Read routes
  * get '/recipes'
  * get '/recipes/:id'
3. Edit routes
  * get '/recipes/:id/edit'
  * patch '/recipes/:id'
4. Delete route: delete '/recipes/:id'
  * One of my ideas for a future version is to add a "get '/recipes/:id/delete" route that renders a page that asks a user if they're sure they want to delete the recipe.
  * If the user says Yes, the recipe is deleted through the delete route above; if the user says no, they are redirected back to the recipe page. 
**Even though the RecipeIngredient is also a belongs_to resource, it does not have CRUD routes as it is simply a JOIN model. All of its CRUD actions are performed automatically through Recipes and Ingredients.**

- [ ] Ensure that users can't modify content created by other users
- [ ] Include user input validations
- [ ] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code **The README includes all of these things and more, but instead of linking to a license, I have directed users to the LICENSE file.**

Confirm
- [ ] You have a large number of small Git commits
- [ ] Your commit messages are meaningful
- [ ] You made the changes in a commit that relate to the commit message
- [ ] You don't include changes in a commit that aren't related to the commit message
