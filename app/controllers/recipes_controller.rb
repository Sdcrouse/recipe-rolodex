class RecipesController < ApplicationController
  # Don't forget to use Rack::MethodOverride in the config.ru file. I may need to require it here as well.

  get '/recipes' do
    # Users should not access this unless logged in, either by clicking on a link (that should be hidden) or by entering the URL.
    @recipes = Recipe.all
    erb :"recipes/index"
  end
end