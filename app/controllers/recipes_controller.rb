class RecipesController < ApplicationController
  # Don't forget to use Rack::MethodOverride in the config.ru file. I may need to require it here as well.

  get '/recipes' do
    if logged_in?
      @recipes = Recipe.all
      erb :"recipes/index"
    else
      redirect to "/users/login" # Add a flash message here.
    end
  end

  get '/recipes/new' do
    if logged_in?
      @ingredients = Ingredient.all
      erb :"/recipes/new"
    else
      redirect to "/users/login" # Add a flash message here.
    end
  end

  post '/recipes' do
    # I decided against having a bunch of nested "if" statements, due to the calls to #redirect exiting the route anyway.
    
    if !logged_in?
      # This is an edge case, but it might not hurt to put a flash message here.
      redirect to "/users/login"
    end

    # I'll need some validations here. See comments below.
    recipe = Recipe.new(params[:recipe])
    
    params[:ingredients].each do |ingredient|      
      if ingredient[:name].blank? && (!ingredient[:amount].blank? || !ingredient[:brand_name].blank?)
        # Note that this will only fire if the ingredient does not have a name, yet somehow has an amount and/or brand_name.
        # Add a flash message like this: "If you specify an amount and/or brand_name, then you must add a name as well."
        redirect to "/recipes/new"
      end
        
      ingred = Ingredient.new(name: ingredient[:name])

      if !ingred.save 
        # Be careful with the validations here. The first ingredient ALWAYS needs a name.
        # However, the other ingredients with blank names don't need to be saved or validated.
        # Be sure to have the appropriate flash message here, too.
        redirect to "/recipes/new"
      end
      
      recipe.ingredients << ingred
      
      if ingredient == params[:ingredients].first && !recipe.save 
        # Make sure to use the appropriate Recipe validations and flash message here.
        redirect to "/recipes/new"
      else
        # "You have successfully created a new recipe!" 
        # Use this as a flash message.

        recipe.recipe_ingredients.last.update(ingredient_amount: params[:ingredients].second[:amount], brand_name: params[:ingredients].second[:brand_name])
        current_user.recipes << recipe
        binding.pry
        redirect to "/recipes/#{recipe.id}"
      end       
    end

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
    @recipe = Recipe.find_by_id(params[:id])
    # Redirect to an error page (or somewhere else, with a flash message), if there is no recipe.
    # I also accounted for this in the recipes/show.erb file.

    @recipe_ingredients = @recipe.recipe_ingredients
    
    erb :'recipes/show'
  end
end