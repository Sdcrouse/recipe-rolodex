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
    # The idea here is to create a recipe with the given params, which has turned out to be tricky due to the complex model relationships and validations.
    # I decided against having a bunch of nested "if" statements, due to the calls to #redirect exiting the route anyway.
    # Later on, I may want to convert blank values to nil with #presence.

    if !logged_in?
      # This is an edge case.
      flash[:error] = "Congratulations, chef! You just found a bug in the Recipe Rolodex! Either you somehow got this far without being logged in, or you got logged out while creating a recipe."
      redirect to "/users/login"
    end

    recipe = Recipe.new(params[:recipe])
    
    params[:ingredients].each do |ingredient|
      unless ingredient[:amount].blank? && ingredient[:brand_name].blank? && ingredient[:name].blank?
        # Depending on the number of ingredients in a recipe, there may be blank ingredients (ingredients without an amount, brand, and name).
        # Those blank ingredients should not be saved, but neither should they trigger any validation errors.

        ingred = Ingredient.find_or_initialize_by(name: ingredient[:name].downcase)
        # Eggs, eggs, EgGs, etc. should be the same ingredient.

        recipe.ingredients << ingred 
        # This also instantiates a new recipe_ingredient, but does not save it.
        
        # My goal is to update the corresponding recipe_ingredient, but I don't want to save the recipe (or anything else) until later.
        # I tried using recipe.recipe_ingredients.last.update, but that saved the recipe and (I think) everything associated with it.
        rec_ingr = recipe.recipe_ingredients.last
        rec_ingr.ingredient_amount = ingredient[:amount]
        rec_ingr.brand_name = ingredient[:brand_name].capitalize
        rec_ingr.ingredient = ingred
      end # End of #unless
    end # End of #each
    
    current_user.recipes << recipe # This automatically attempts to save the recipe, so I don't have to save the recipe before this point.
    if recipe.persisted?
      # Note that I can also call #new_record? to see whether the recipe has ever been saved.
      # #persisted? checks to see that the recipe has been saved/persisted AND not destroyed.
      
      redirect to "/recipes/#{recipe.id}"
    else
      flash[:validations] = recipe.errors.full_messages
      redirect to "/recipes/new" # I could have done this earlier, but I wanted to get ALL of the error messages, not just one.
    end
  end # End of " post '/recipes' " route

  get '/recipes/:id' do
    if logged_in? && @recipe = Recipe.find_by_id(params[:id])
      @recipe_ingredients = @recipe.recipe_ingredients
      # As noted in the show.erb file, I think this will prevent more database queries than are necessary.
      
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

  get '/recipes/:id/edit' do
    if logged_in?
      @recipe = Recipe.find_by_id(params[:id])

      if !@recipe # The recipe does not exist.
        flash[:error] = "Sorry, Chef #{current_user.username}! The recipe that you are trying to edit does not exist."
        redirect to "/recipes"
      elsif @recipe.user != current_user
        # The recipe exists, but the current_user is not its author (and is thus not allowed to edit it).
        
        flash[:error] = "Sorry, Chef #{current_user.username}! You are not authorized to edit this recipe."
        redirect to "/recipes/#{@recipe.id}"
      else # The recipe exists and the current_user is allowed to edit it.
        erb :"/recipes/edit"
      end # End of "if !@recipe"
    else
      flash[:error] = "Sorry, Chef! You must be logged in to edit this recipe."
      redirect to "/users/login"
    end # End of "if logged_in?"
  end # End of "get '/recipes/:id/edit'" route

  patch '/recipes/:id' do
    "You have successfully edited the recipe!" # This could be a flash message.
  end
end # End of RecipesController