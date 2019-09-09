class UsersController < ApplicationController
  get '/users/signup' do
    binding.pry
    erb :"users/signup"
  end

  post '/users' do
    new_user = User.new(params)
    # I need a validation or two here - don't create a blank user!
    new_user.save

    session[:user_id] = new_user.id # This should only happen if the user CORRECTLY signs up.

    # I want to use a #slug method here, and redirect to '/users/slug' (or something similar)
    redirect to "/users/#{new_user.id}"
  end

  get '/users/:id' do
    @user = User.find_by_id(params[:id])
    erb :"users/profile"
  end
end