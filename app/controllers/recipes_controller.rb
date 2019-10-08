class RecipesController < ApplicationController
  get '/recipes' do
    if logged_in?
      @recipes = Recipe.all
      erb :"recipes/index"
    else
      flash[:error] = "You must be logged in to view the recipes."
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

    if !logged_in? # This is an edge case.
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
        rec_ingr.brand_name = ingredient[:brand_name]
        rec_ingr.ingredient = ingred # Is this needed?
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
        @all_ingredients = Ingredient.all
        # My goal here ^^^ is to create 5 ingredient fields in the edit form.
        # I need to know how many will be blank, based on how many recipe_ingredients are in the original recipe.

        erb :"/recipes/edit"
      end # End of "if !@recipe"
    else
      flash[:error] = "Sorry, Chef! You must be logged in to edit this recipe."
      redirect to "/users/login"
    end # End of "if logged_in?"
  end # End of "get '/recipes/:id/edit'" route

  patch '/recipes/:id' do
    if !logged_in? 
      # This is an edge case. I don't know why it won't work when I clear the session just before calling #logged_in? 
      # Update: I also have to set the session[:user_id] to nil; clearing the session won't work.
      flash[:error] = "Congratulations, chef! You just found a bug in the Recipe Rolodex! Either you somehow got this far without being logged in, or you got logged out while editing a recipe."
      redirect to "/users/login"
    end

    recipe = Recipe.find_by_id(params[:id])

    if recipe.user != current_user 
      # Another edge case. I got it to work by changing the session's user_id and resetting @logged_in_user to User.find_by_id(session[:user_id]).
      flash[:error] = "Congratulations, chef! You just found a bug in the Recipe Rolodex! You should not have gotten this far, since you are not authorized to edit this recipe."
      redirect to "/recipes/#{recipe.id}"
    end

    params[:ingredients].each do |ingred| # Check for invalid ingredients.
      if ingred[:name].blank? && (!ingred[:amount].blank? || !ingred[:brand_name].blank?) # I need those () because Ruby and/or ActiveRecord and/or Sinatra is PICKY!
        flash[:error] = "An ingredient needs a name when it's given an amount and/or brand"
        redirect to "/recipes/#{recipe.id}/edit"
      end
    end
    
    # Update the recipe's ingredients. All of this works because the recipe now accepts nested attributes for recipe_ingredients.
    recipe.recipe_ingredients.each_with_index do |rec_ingr, index|
      rec_ingr.ingredient_amount = params[:ingredients][index][:amount]
      rec_ingr.brand_name = params[:ingredients][index][:brand_name]

      ingredient_name = params[:ingredients][index][:name].downcase

      if ingredient_name != rec_ingr.ingredient.name
        # If the user changes the ingredient's name, find or create that ingredient, then store it as the recipe_ingredient's new ingredient.
        rec_ingr.ingredient = Ingredient.find_or_create_by(name: ingredient_name)
      end
    end
    
    # But what if the user removes an ingredient? ^^^
    # That is a stretch goal. When I implement it, the user should also be able to delete the first ingredient, for consistency (so remove the "required" keyword).
    # I should also probably remove the "required" keywords from the "new recipe" and "edit recipe" forms, so that the corresponding validations and flash messages will be run.
    
    ingredient_total = recipe.recipe_ingredients.size
    # Note: It's better to count the recipe's recipe_ingredients than its ingredients, because this will avoid a SQL query.
    # For the same reason, use #length or #size instead of #count.

    # Create new ingredients specified by the user, from the remaining params that don't correspond to the recipe's original ingredients.
    params[:ingredients][ingredient_total..-1].each do |ingred|
      unless ingred[:amount].blank? && ingred[:brand_name].blank? && ingred[:name].blank?
        recipe.ingredients << Ingredient.find_or_create_by(name: ingred[:name])
        recipe.recipe_ingredients.last.ingredient_amount = ingred[:amount]
        recipe.recipe_ingredients.last.brand_name = ingred[:brand_name]
      end
    end
    
    # At this time, I get strange results when I make every ingredient blank (and remove the "required" keyword from the "edit recipe" form).
    # No errors, and the recipe gets new ingredients (duplicates with blank names) and recipe_ingredients (with blank amounts and brand names).
    # The Recipe model's #recipe_should_have_at_least_one_ingredient validation does NOT get triggered.
    
    # Another stretch goal: change the params hash structure so that I can make better use of the #accepts_nested_attributes_for macro.
    # Yet another stretch goal: In the "create" and "edit" routes, identify the invalid ingredients in the flash message (Ingredient 1 needs a name, Ingredient 3 needs a name, etc.)

    recipe.update(params[:recipe]) # Doing this should simultaneously validate the recipe's params and the recipe_ingredients (both of which are now edge cases).
    
    if recipe.errors.full_messages.blank? # This is an edge case, at this point.
      flash[:message] = "You have successfully edited the recipe!"
      redirect to "/recipes/#{recipe.id}"
    else
      flash[:validations] = recipe.errors.full_messages
      redirect to "/recipes/#{recipe.id}/edit"
    end
  end

  delete '/recipes/:id' do
    if !logged_in? # Edge case
      flash[:error] = "You must be logged in to delete this recipe."
      redirect to "/users/login"
    else
      recipe = Recipe.find_by_id(params[:id])
      
      if !recipe # Edge case
        flash[:error] = "This recipe does not exist."
        redirect to "/recipes"
      elsif recipe.user != current_user # Edge case ("Delete Recipe" button only shows up for the authorized user)
        flash[:error] = "Sorry, Chef #{current_user.username}! You are not authorized to delete this recipe."
        redirect to "/recipes/#{recipe.id}"
      else # The user is logged in, the recipe exists, and the user is authorized to delete it.
        recipe.destroy
        flash[:message] = "You have successfully deleted the recipe!"
        redirect to "/recipes"
      end # End of "if !recipe"
    end # End of "if !logged_in?"
  end # End of "delete '/recipes/:id'" route
end # End of RecipesController