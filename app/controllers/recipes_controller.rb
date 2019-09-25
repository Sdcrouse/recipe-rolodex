class RecipesController < ApplicationController
  # Don't forget to use Rack::MethodOverride in the config.ru file. I may need to require it here as well.

  get '/recipes' do
    if logged_in?
      @recipes = Recipe.all
      erb :"recipes/index"
    else
      flash[:message] = "You must be logged in to view the recipes." unless !flash[:errors].blank?
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
      flash[:errors] = "Sorry, chef! You must be logged in before you can create a new recipe."
      redirect to "/users/login"
    end
  end

  post '/recipes' do
    # I decided against having a bunch of nested "if" statements, due to the calls to #redirect exiting the route anyway.
    
    if !logged_in?
      # This is an edge case.
      flash[:errors] = "Congratulations, chef! You just found a bug in the Recipe Rolodex! Either you somehow got this far without being logged in, or you got logged out while creating a recipe."
      redirect to "/users/login"
    end

    # I'll need some validations here. See comments below.
    recipe = Recipe.new(params[:recipe])
    
    params[:ingredients].each do |ingredient|
      # Make the ingredient
      # Try to save the ingredient (which will NOT save if it's missing a name).
      # If it saves, great! 
        # Add the ingredient to the recipe's ingredients.
        # Save the recipe if it hasn't been saved yet.
        # Add the ingredient_amount and brand_name to the recipe's recipe_ingredients.
        # (I may want to convert blank values to nil with #presence).
      # If it does NOT save:
        # Do NOT save it to the recipe's ingredients!
        # Do not update the recipe with the ingredient_amount and brand_name unless the corresponding ingredient has been saved.
      
      ingred = Ingredient.find_or_initialize_by(name: ingredient[:name].downcase)
      binding.pry

      if ingred.save
        recipe.ingredients << ingred
        binding.pry

        # Note that I can also call #persisted? to see whether the recipe has been saved AND not destroyed.
        # I don't need to call #save if the ingredient is added to an already-persisted recipe; it updates automatically.
        if recipe.new_record?
          binding.pry
          recipe.save
          binding.pry
        end
        
        # For some reason, when the recipe is saved or updated, ingred is in the recipe's ingredients, but the recipe is NOT in ingred's ingredients!
        # Yet, somehow the recipe's recipe_ingredient is among ingred's recipe_ingredients.
        
        recipe.recipe_ingredients.last.update(ingredient_amount: ingredient[:amount], brand_name: ingredient[:brand_name].capitalize)
        binding.pry
        # Here, though, the recipe's recipe_ingredients got updated, but ingred's did not.
        # I'm getting inconsistent results. Sometimes, the ingredient DOES get updated, but without the recipe being added to its recipes.
      elsif !ingredient[:amount].blank? || !ingredient[:brand_name].blank?
        # Add a flash message like this: "If you specify an amount and/or brand_name, then you must give your ingredient name as well."
        # Either that, or use the ActiveRecord error message for an ingredient that wasn't persisted.
        binding.pry
        redirect to "/recipes/new"
      end
      binding.pry
   #
      #if !ingred.save && (!ingredient[:amount].blank? || !ingredient[:brand_name].blank?)
      #  # Note that this will only fire if the ingredient does not have a name, yet somehow has an amount and/or brand_name.
      #  # Add a flash message like this: "If you specify an amount and/or brand_name, then you must add a name as well."
      #  redirect to "/recipes/new"
      #end
      #  
      #if !ingred.save # This is where I should check for blank-named ingredients, and whether other params have been saved.
      #  # Be careful with the validations here. The first ingredient ALWAYS needs a name.
      #  # However, the other ingredients with blank names don't need to be saved or validated.
      #  # Be sure to have the appropriate flash message here, too.
      #  redirect to "/recipes/new"
      #end
      #
      #recipe.ingredients << ingred
      #
      #if ingredient == params[:ingredients].first || !ingredient[:name].blank? && !recipe.save 
      #  # Does this work? What if the first ingredient somehow has a blank name and doesn't get saved? Then what?
      #  # Then, if there are any subsequent valid ingredients, I don't think they'd get saved properly.
      #  # The recipe should be saved for the first valid ingredient, since it hasn't been saved yet.
      #  # But further calls to #save aren't necessary because "recipe.ingredients << ingred" updates the recipe automatically.
      #  # Make sure to use the appropriate Recipe validations and flash message here.
      #  redirect to "/recipes/new"
      #else
      #  # "You have successfully created a new recipe!" 
      #  # Use this as a flash message.
#
      #  recipe.recipe_ingredients.last.update(ingredient_amount: ingredient[:amount], brand_name: ingredient[:brand_name])
      #end       
    end

    # The recipe should have at least ONE ingredient.
    # If it does not, then destroy the recipe and redirect back to the "new recipe" form with an error message.
    # The recipe should also have a name and instructions; redirect with an error message (without saving the recipe) if it lacks either one.
    # If successful, use this flash message: "You have successfully created a new recipe!"

    current_user.recipes << recipe
    redirect to "/recipes/#{recipe.id}"

    # This apparently works (for the first ingredient):
    # recipe = Recipe.new(params[:recipe])
    # ingred = Ingredient.create(name: params[:ingredients].first[:name])
    # recipe.ingredients << ingred
    # recipe.save

    # This works for the second ingredient and beyond:
    # ingred2 = Ingredient.create(name: params[:ingredients].second[:name])
    # recipe.ingredients << ingred2
    # recipe.recipe_ingredients.last.update(ingredient_amount: params[:ingredients].second[:amount], brand_name: params[:ingredients].second[:brand_name]")
    
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
        # I don't know how to recreate it, but evidently the former flash[:errors] message wasn't overwritten.

        flash[:errors] = "You must be logged in before you can view this recipe."
        redirect to "/users/login"
      else # The user is logged in, but the recipe does not exist.
        flash[:errors] = "Sorry, chef! That recipe doesn't exist."
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