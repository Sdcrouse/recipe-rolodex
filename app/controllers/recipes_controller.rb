class RecipesController < ApplicationController
  get '/recipes' do
    redirect_if_not_logged_in

    @recipes = Recipe.sort_recipes(Recipe.all)
    erb :"recipes/index"
  end

  get '/recipes/new' do
    redirect_if_not_logged_in
    
    @ingredients = Ingredient.all
    erb :"/recipes/new"
  end

  post '/recipes' do
    # The idea here is to create a recipe with the given params.
    # This has turned out to be tricky, due to the complex model relationships and validations.
    
    redirect_if_not_logged_in("create a recipe") # Important edge case

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
        # This should (in theory) trigger the right validations at the right time.
        # I tried using recipe.recipe_ingredients.last.update, but that saved the recipe and (I think) everything associated with it.
        rec_ingr = recipe.recipe_ingredients.last
        rec_ingr.ingredient_amount = ingredient[:amount]
        rec_ingr.brand_name = ingredient[:brand_name]
        rec_ingr.ingredient = ingred # I think this is needed because the recipe hasn't been saved yet.
      end # End of #unless
    end # End of #each
    
    current_user.recipes << recipe
    # This automatically attempts to save the recipe, so I don't have to save it before this point.
    
    if recipe.persisted?
      # Note that I can also call #new_record? to see whether the recipe has ever been saved.
      # #persisted? checks to see that the recipe has been saved/persisted AND not destroyed.
      
      flash[:success] = "You have successfully created the recipe!"
      redirect to "/recipes/#{recipe.id}"
    else
      flash[:validations] = recipe.errors.full_messages # This is likely an edge case, for the moment.
      redirect to "/recipes/new" # I could have done this earlier, but I wanted to get ALL of the error messages, not just one.
    end
  end # End of " post '/recipes' " route

  get '/recipes/:id' do
    redirect_if_not_logged_in

    @recipe = Recipe.find_by_id(params[:id])

    redirect_if_nonexistent(@recipe) # I will refactor this later (if possible) so that I don't need to pass an instance variable.

    @recipe_ingredients = @recipe.recipe_ingredients
    # I think this will prevent more database queries than are necessary.
    
    erb :'recipes/show'
  end # End of "get '/recipes/:id'" route

  get '/recipes/:id/edit' do
    redirect_if_not_logged_in

    @recipe = Recipe.find_by_id(params[:id])

    redirect_if_nonexistent(@recipe)
      
    redirect_if_unauthorized_user_tries_to("edit this recipe", @recipe)
    # It is unusual to pass an instance variable to a method like this.
    # However, it's easier than changing local variables to instance variables in other routes (and testing for bugs).
    # I will try to refactor this and the method above it later, so that I won't have to send instance variables.

    # By this point, the recipe exists and the user is authorized to edit it.
    @all_ingredients = Ingredient.all
    # My goal here ^^^ is to create 5 ingredient fields in the edit form.
    # I need to know how many will be blank, based on how many recipe_ingredients are in the original recipe.

    erb :"/recipes/edit"
  end # End of "get '/recipes/:id/edit'" route

  patch '/recipes/:id' do
    redirect_if_not_logged_in("update a recipe") # Important edge case

    recipe = Recipe.find_by_id(params[:id])

    redirect_if_unauthorized_user_tries_to("edit this recipe", recipe) # Important edge case

    params[:ingredients].each do |ingred| # Check for invalid ingredients.
      if ingred[:name].blank? && (!ingred[:amount].blank? || !ingred[:brand_name].blank?) 
        # I need those ()'s above because Ruby and/or ActiveRecord and/or Sinatra is PICKY with the order of logical operators!

        flash[:error] = "An ingredient needs a name when it's given an amount and/or brand"
        redirect to "/recipes/#{recipe.id}/edit"
      end
    end
    
    # Updates the recipe's ingredients. All of this works because the recipe accepts nested attributes for recipe_ingredients.
    recipe.recipe_ingredients.each_with_index do |rec_ingr, index|
      rec_ingr.ingredient_amount = params[:ingredients][index][:amount]
      rec_ingr.brand_name = params[:ingredients][index][:brand_name]

      ingredient_name = params[:ingredients][index][:name].downcase

      if ingredient_name != rec_ingr.ingredient.name
        # If the user changes the ingredient's name, find or create that ingredient, then store it as the recipe_ingredient's new ingredient.
        rec_ingr.ingredient = Ingredient.find_or_create_by(name: ingredient_name)
      end
    end
     
    ingredient_total = recipe.recipe_ingredients.size

    # Create new ingredients specified by the user, from the remaining params that don't correspond to the recipe's original ingredients.
    params[:ingredients][ingredient_total..-1].each do |ingred|
      unless ingred[:amount].blank? && ingred[:brand_name].blank? && ingred[:name].blank?
        recipe.ingredients << Ingredient.find_or_create_by(name: ingred[:name])
        recipe.recipe_ingredients.last.ingredient_amount = ingred[:amount]
        recipe.recipe_ingredients.last.brand_name = ingred[:brand_name]
      end
    end
    
    recipe.update(params[:recipe]) # Doing this should simultaneously validate the recipe's params and the recipe_ingredients (both of which are now edge cases).
    
    if recipe.errors.full_messages.blank? # This is an edge case, at this point.
      flash[:success] = "You have successfully edited the recipe!"
      redirect to "/recipes/#{recipe.id}"
    else
      flash[:validations] = recipe.errors.full_messages
      redirect to "/recipes/#{recipe.id}/edit"
    end
  end

  delete '/recipes/:id' do
    redirect_if_not_logged_in("delete a recipe") # Important edge case

    recipe = Recipe.find_by_id(params[:id])
    
    if !recipe # Edge case
      flash[:error] = "This recipe does not exist."
      redirect to "/recipes"
    else
      redirect_if_unauthorized_user_tries_to("delete this recipe", recipe) # Important edge case
      
      # The user is logged in, the recipe exists, and the user is authorized to delete it.
      recipe.destroy
      flash[:success] = "You have successfully deleted the recipe!"
      redirect to "/recipes"
    end # End of "if !recipe"
  end # End of "delete '/recipes/:id'" route

  helpers do
    def redirect_if_unauthorized_user_tries_to(action, recipe)
      # Note that the recipe will either be a local or instance variable. This will be changed later.

      if recipe.user != current_user
        # The current_user is not this recipe's author (and is thus not allowed to edit or delete it).

        flash[:error] = "Sorry, Chef #{current_user.username}! You are not authorized to #{action}."
        redirect to "/recipes/#{recipe.id}"
      end
    end

    def redirect_if_nonexistent(obj)
      if !obj
        flash[:error] = "This recipe does not exist."
        redirect to "/recipes"
      end
    end
  end # End of helpers
end # End of RecipesController