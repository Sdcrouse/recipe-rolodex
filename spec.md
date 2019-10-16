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

- [x] Ensure that users can't modify content created by other users
**Each recipe's page has Edit and Delete buttons that are only visible to the user that created it. If an unauthorized user tries to bypass this and access the Edit form through a URL, they will be redirected back to the recipe page with an error message. There is also no URL that redirects to a Delete page (yet). If a user is somehow able to bypass all of this and get to the PATCH or DELETE routes, there are redirects and error messages for those edge cases.**

- [x] Include user input validations
**There are a lot of these in the models, views, and controllers; some I wrote myself, and others are HTML or ActiveRecord validations. Here is a summary of them:**
* Some views, such as the new recipe form and the login form, have the 'required' keyword in required inputs, like username, recipe name, and instructions. I have also set certain input types like "url" and "password", which have validations of their own.
* In the User models, there are a few ActiveRecord validations, some standard and some custom. The User model also uses the has_secure_password macro from the bcrypt gem (and has the corresponding password_digest attribute in the users table).
* The controllers also have a few custom validations, primarily error messages and redirects when the user tries to access certain pages when not logged in, or when users try to edit recipes they did not create, or when someone tries to look for a user or recipe that does not exist.
* As I went overboard with this project, there are quite a few edge-case validations.

- [x] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
**I used these extensively with the rack-flash gem and split them into three categories: login, error, and success. Login messages (indicating whether the user is currently logged in or out) have blue text, error messages have red text, and success messages (logging in successfully, creating/editing a recipe, etc.) have green text. These are conditionally displayed in most of the ERB files. Most flash messages are custom, but some are standard ActiveRecord and Bcrypt validation errors.** 

- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code **The README includes all of these things and more, but instead of linking to a license, I have directed users to the LICENSE file.**

Confirm
- [x] You have a large number of small Git commits
**This is true for the most part; there are over 200 commits now. I admit, however, that there is a decent number of them that probably could have been split into smaller commits.**

- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
**I did my best to follow the three criteria above in a consistent manner. There may have been a few changes that were not mentioned in a commit, simply because they were very minor (adding spacing, editing a comment here and there, etc). Many times, I summarized the main changes in a commit message and added a paragraph below it that explains the changes in more detail.**