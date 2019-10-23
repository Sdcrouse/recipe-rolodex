class UsersController < ApplicationController
  get '/users/signup' do
    if !logged_in?
      erb :"users/signup"
    else
      flash[:error] = "You don't need to sign up, Chef #{current_user.username}. You're already logged in!"
      redirect to "/users/#{current_user.username}"
    end
  end

  post '/users' do
    new_user = User.new(params)
    
    if new_user.save
      session[:user_id] = new_user.id # This should only happen if the user CORRECTLY signs up.
      # See https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html for how to confirm a password.

      flash[:success] = "You have successfully signed up!"
      redirect to "/users/#{new_user.username}"
    else
      flash[:validations] = new_user.errors.full_messages
      redirect to "/users/signup"
    end
  end

  get '/users/login' do
    if !logged_in?
      flash[:login] = "You are not logged in."
      erb :"users/login"
    else
      flash[:error] = "Silly chef, you're ALREADY logged in!"
      redirect to "/users/#{current_user.username}"
    end
  end

  post '/users/login' do
    # Log the user in if the user exists and has the correct password.
    # Otherwise, redirect them to the login page, with a flash message.

    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You have successfully logged in!"
      redirect to "/users/#{user.username}"
    else
      if user.nil?
        flash[:error] = "This chef does not exist."
      else # The user exists, but the password is incorrect.
        flash[:error] = "Invalid password. Try again."
      end
      redirect to "/users/login"
    end
  end

  get '/users/logout' do
    if logged_in?
      session.clear
      flash[:success] = "You have successfully logged out!"
      # Later, I may instead render a separate logout.erb page to confirm the user's choice; see comments below.
    else
      flash[:error] = "Sorry, chef! You can't log out unless you're logged in."
    end
    
    redirect to "/users/login"
  end

  get '/users/:username' do
    # Show users this user's profile, but ONLY if they are logged in and that user exists.
    
    redirect_if_not_logged_in

    if @user = User.find_by(username: params[:username])
      @user_recipes = Recipe.sort_recipes(@user.recipes)
      erb :"users/profile"
    else
      # The current_user is logged in, but @user does not exist.
      flash[:error] = "It looks like this chef does not exist."
      redirect to "/" # Change this to "/users" later on (stretch goal).
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
  #   flash[:success] = "You have successfully logged out!"
  # end
end