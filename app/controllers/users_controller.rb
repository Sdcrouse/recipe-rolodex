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

  get '/users/login' do
    erb :"users/login"
  end

  post '/users/login' do
    "You are now logged in!" # Use this as a flash message.
  end

  get '/users/logout' do
    session.clear
    redirect to "/"
  end

  get '/users/:id' do
    @user = User.find_by_id(params[:id])
    erb :"users/profile"
  end

  # Later on, I want to render a logout.erb page that confirms the user's choice to log out.
  # That would require a get '/users/:id/logout' route (and I would need to update the corresponding <a> on the layout page).
  # If they say "No", then redirect them to their profile page.
  # This will be easier to implement (I think), once the login and logout links are only shown when the user is respectively logged out or in.

  # get '/users/:id/logout' do
  #   @user = User.find_by_id(params[:id])
  #   erb :"users/logout"
  # end

  # post '/users/logout' do
  #   "You have successfully logged out!" # This could be a flash message.
  # end
end