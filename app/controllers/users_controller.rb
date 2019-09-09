class UsersController < ApplicationController
  get '/users/signup' do
    erb :"users/signup"
  end

  post '/users' do
    new_user = User.new(params)
    # I need a validation or two here - don't create a blank user!
    new_user.save

    # I want to use a #slug method here, and redirect to '/users/slug' (or something similar)
    redirect to "/users/#{new_user.id}"
  end

  get '/users/:id' do
    @user = User.find_by_id(params[:id])
    erb :"users/profile"
  end
end