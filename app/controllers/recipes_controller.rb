class RecipesController < ApplicationController
  # Don't forget to use Rack::MethodOverride in the config.ru file. I may need to require it here as well.

  get '/recipes' do
    if logged_in?
      @recipes = Recipe.all
      erb :"recipes/index"
    else
      flash[:message] = "You must be logged in to view the recipes." unless !flash[:error].blank?
      # Other routes with error messages of their own redirect here, so the #unless statement above is needed.
      # There may be a bug that causes that flash message to not show up, but I haven't been able to recreate it.
      redirect to "/users/login"
    end
  end

  get '/recipes/new' do
    if logged_in?
      @ingredients = Ingredient.all
      erb :"/recipes/new"
    else
      flash[:error] = "Sorry, chef! You must be logged in before you can create a new recipe."
      redirect to "/users/login"
    end
  end

  post '/recipes' do
    # I decided against having a bunch of nested "if" statements, due to the calls to #redirect exiting the route anyway.
    
    if !logged_in?
      # This is an edge case.
      flash[:error] = "Congratulations, chef! You just found a bug in the Recipe Rolodex! Either you somehow got this far without being logged in, or you got logged out while creating a recipe."
      redirect to "/users/login"
    end

    recipe = Recipe.new(params[:recipe])

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
    
    params[:ingredients].each do |ingredient|
      ingred = Ingredient.find_or_initialize_by(name: ingredient[:name].downcase)
      binding.pry

      if !ingred.name.blank?
        recipe.ingredients << ingred # This also instantiates a new recipe_ingredient, but does not save it.
        
        # I tried using recipe.recipe_ingredients.last.update, but that saves the recipe and (I think) everything associated with it.
        # I don't want to save the recipe until later.
        rec_ingr = recipe.recipe_ingredients.last
        rec_ingr.ingredient_amount = ingredient[:amount]
        rec_ingr.brand_name = ingredient[:brand_name].capitalize
        rec_ingr.ingredient = ingred
      end
      binding.pry
    end

    recipe.save

    # The recipe should have at least ONE ingredient.
    # The recipe should also have a name and instructions; redirect with an error message (without saving the recipe) if it lacks either one.
    # If successful, use this flash message: "You have successfully created a new recipe!"
    
    #flash[:validations] = recipe.errors.full_messages # This will be implemented in the next commit.
    binding.pry
    current_user.recipes << recipe if recipe.persisted? 
    # Note that I can also call #new_record? to see whether the recipe has ever been saved.
    # #persisted? checks to see that the recipe has been saved/persisted AND not destroyed.
    
    #redirect to "/recipes/new"
    redirect to "/recipes/#{recipe.id}" 
  end

  get '/recipes/:id' do
    if logged_in? && @recipe = Recipe.find_by_id(params[:id])
      @recipe_ingredients = @recipe.recipe_ingredients
      erb :'recipes/show'
    else
      # Redirect, if there is no recipe and/or the user is not logged in.
      # Later, I could make a separate error page.
      # I also accounted for this in the recipes/show.erb file.
      
      if !logged_in?
        # Odd; I encountered a bug that used the '/recipes/new' flash message instead. But how?
        # I don't know how to recreate it, but evidently the former flash[:error] message wasn't overwritten.

        flash[:error] = "You must be logged in before you can view this recipe."
        redirect to "/users/login"
      else # The user is logged in, but the recipe does not exist.
        flash[:error] = "Sorry, chef! That recipe doesn't exist."
        redirect to "/recipes"
      end
    end # End of "if logged_in? && @recipe..."
  end # End of "get '/recipes/:id'" route

  get '/recipes/:id/edit' do # I still need to test this out, after seeding the database.
    @recipe = Recipe.find_by_id(params[:id])
    if @recipe
      if logged_in? && @recipe.user == current_user
        erb :"/recipes/edit"
      else
        # Add a flash message here.
        redirect to "/recipes/#{@recipe.id}"
      end
    else
      "<h2>This recipe does not exist. <a href='/recipes'>Click here to go to the recipes.</a></h2>"
      # This should probably be in a flash message that shows up after redirecting to /recipes.
    end
  end
end