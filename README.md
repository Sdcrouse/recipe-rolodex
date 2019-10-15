# Recipe Rolodex
Welcome to the Recipe Rolodex! This is a Sinatra app that allows you to create an account, log in and out, and create, read, update, and delete your own recipes.

Eventually, this app will be available on the web, so you'll be able to view other people's recipes as well.

## Features
In addition to the CRUD functionality mentioned above, users are able to:
* View their information and recipes on their profile pages.
* Choose from a list of ingredients and/or create a new ingredient.
  * Note that every time you create a new ingredient, its name gets added to the list of available ingredient names.
* Add an image URL, serving size and servings, description, notes, and other information to their recipes.
* See error messages (such as when logging in with invalid credentials or try to edit someone else's recipe) and get redirected to the appropriate page.

## Installation
As this Sinatra app is not yet available outside of Github, you will need to download and install it here. Here's how:
1. Fork and clone this project into your own repository.
2. Run ```bundle install``` to install any missing gems into your local environment.
3. Run ```rake db:migrate``` to set up the database.
  * (Optional): Run ```rake db:seed``` to give your database some sample data.
4. Run ```shotgun```, and navigate to the website shown in your terminal.

You're all set to use the app!

## Development Notes
Google Chrome's cache is "weird". If you want to see any changes that you make to your CSS file(s), you will need to do a hard refresh in your browser. Exiting and restarting Shotgun will not work.

Also, if you want to see my thought process when making this project, my stretch goals, and my ideas for later versions of this app, check out the NOTES.md file.

You can run a test suite with ```rspec spec/application_controller_spec.rb```. (You may have to run ```rake db:migrate SINATRA_ENV=test``` first.)

Because of the ActiveRecord macros used, whenever a user or developer deletes a recipe or ingredient, the associated recipe_ingredient is also destroyed.

## Contributing
Please feel free to raise a new Issue on my repository if you have any problems with my app (installation, usage, bugs, etc), or you have suggestions for a new feature. Pull requests are also welcome.

Contributors are expected to follow the project's code of conduct. This can be viewed in the CODE_OF_CONDUCT.md file.

## License
The Recipe Rolodex app is available as open source under the terms of the MIT License, which can be viewed in the LICENSE file.