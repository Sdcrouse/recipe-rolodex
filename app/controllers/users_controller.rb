class UsersController < ApplicationController
  get '/users/signup' do
    # The user should ONLY be able to access this when logged out, not when logged in.
    erb :"users/signup"
  end

  post '/users' do
    new_user = User.new(params)
    # I need a validation or two here - don't create a blank user!
    new_user.save

    session[:user_id] = new_user.id # This should only happen if the user CORRECTLY signs up.
    # See https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html for how to confirm a password.

    # I want to use a #slug method here, and redirect to '/users/slug' (or something similar). Edit: That may not work; see NOTES.md.
    redirect to "/users/#{new_user.id}"
  end

  get '/users/login' do
    # The user should ONLY be able to access this when logged out, not logged in.
    erb :"users/login"
  end

  post '/users/login' do
    # Log the user in if the user exists and has the correct password.
    # Otherwise, redirect them to the login page, with a flash message.

    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      # "You have successfully logged in!" # Use this as a flash message.
      redirect to "/users/#{user.id}"
    else
      redirect to "/users/login" # Use a flash message here.
    end
  end

  get '/users/logout' do
    # Users should ONLY be able to access this when logged in, not when they're logged out.
    session.clear
    redirect to "/" # Maybe redirect to the login page instead.
  end

  get '/users/:id' do
    # Users can only access this when they're logged in; also, the current_user should see more info than anyone else.
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