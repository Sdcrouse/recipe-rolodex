class UsersController < ApplicationController
  get '/users/signup' do
    if !logged_in?
      erb :"users/signup"
    else
      flash[:login] = "You don't need to sign up, Chef #{current_user.username}. You're already logged in!"
      redirect to "/users/#{current_user.username}"
    end
  end

  post '/users' do
    new_user = User.new(params)
    
    if new_user.save
      session[:user_id] = new_user.id # This should only happen if the user CORRECTLY signs up.
      # See https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html for how to confirm a password.

      redirect to "/users/#{new_user.username}"
    else
      flash[:errors] = new_user.errors.full_messages
      binding.pry
      redirect to "/users/signup"
      # Add a flash message here, with the ActiveRecord-generated error messages (new_user.errors.full_messages).
    end
  end

  get '/users/login' do
    if !logged_in?
      erb :"users/login"
    else
      redirect to "/users/#{current_user.username}"
      # Have a Flash message here that tells users that they are already logged in.
    end
  end

  post '/users/login' do
    # Log the user in if the user exists and has the correct password.
    # Otherwise, redirect them to the login page, with a flash message.

    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:login] = "You have successfully logged in!"
      redirect to "/users/#{user.username}"
    else
      redirect to "/users/login" # Use a flash message here.
    end
  end

  get '/users/logout' do
    if logged_in?
      session.clear
      redirect to "/users/login" # Have a flash message that tells users that they have logged out.
      # Later, I may instead render a separate logout.erb page to confirm the user's choice; see comments below.
    else
      redirect to "/" # Have a flash message that tells users that they can only log out if logged in.
    end
  end

  get '/users/:username' do
    # Show users this user's profile, but ONLY if they are logged in and that user exists.
    if logged_in? && @user = User.find_by(username: params[:username])
      erb :"users/profile"
    else
      redirect to "/" # Have two different flash messages here: one for when the user is logged out, and one for when @user is nil.
    end
  end

  # Later on, I want to render a logout.erb page that confirms the user's choice to log out.
  # That would require a get '/users/:username/logout' route (and I would need to update the corresponding <a> on the layout page).
  # If they say "No", then redirect them to their profile page.
  # This will be easier to implement (I think), once the login and logout links are only shown when the user is respectively logged out or in.

  # get '/users/:username/logout' do
  #   @user = User.find_by(name: params[:username])
  #   erb :"users/logout"
  # end

  # post '/users/logout' do
  #   "You have successfully logged out!" # This could be a flash message.
  # end
end