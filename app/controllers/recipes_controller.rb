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
    if logged_in?
      # I'll probably need some validations here, like if the user creates an ingredient without a name or amount.
      binding.pry
      recipe = Recipe.new(params[:recipe])
      recipe.save
      current_user.recipes << recipe
      redirect to "/recipes/#{recipe.id}"
      # "You have successfully created a new recipe!" # Use this as a flash message. This should only happen to the current_user.
      
      # This apparently works (for the first ingredient):
      # recipe = Recipe.new(params[:recipe])
      # ingred = Ingredient.create(name: params[:ingredients].first[:name])
      # recipe.ingredients << ingred
      # recipe.save

      # This works for the second ingredient and beyond:
      # ingred2 = Ingredient.create(name: params[:ingredients].second[:name])
      # recipe.ingredients << ingred2
      # recipe.recipe_ingredients.last.update(ingredient_amount: params[:ingredients].second[:amount], brand_name: params[:ingredients].second[:brand_name]")
    else
      redirect to "/users/login"
      # This is an edge case, but it might not hurt to put a flash message here.
    end
  end

  get '/recipes/:id' do
    @recipe = Recipe.find_by_id(params[:id])
    # Redirect to an error page (or somewhere else, with a flash message), if there is no recipe.
    # I also accounted for this in the recipes/show.erb file.

    @recipe_ingredients = @recipe.recipe_ingredients
    
    erb :'recipes/show'
  end
end