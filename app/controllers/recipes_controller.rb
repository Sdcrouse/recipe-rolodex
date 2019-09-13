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
    erb :"/recipes/new" # Only the current_user should be able to do this!
  end

  post '/recipes' do
    binding.pry
    "You have successfully created a new recipe!" # Use this as a flash message. This should only happen to the current_user.
  end

  get '/recipes/:id' do
    @recipe = Recipe.find_by_id(params[:id])

    # Redirect to an error page (or somewhere else, with a flash message), if there is no recipe.
    # I also accounted for this in the recipes/show.erb file.
    
    erb :'recipes/show'
  end
end