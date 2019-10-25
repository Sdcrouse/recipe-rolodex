require './config/environment'
# require 'sinatra/flash'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "kookaburra_cockadoodle" # It sounded funny; what can I say?
    # register Sinatra::Flash
    use Rack::Flash
  end

  get "/" do
    if !logged_in?
      flash[:login] = "You are not logged in."
    else
      flash[:login] = "You are logged in."
    end

    erb :index
  end

  helpers do
    def current_user
      # The user who is currently logged in, i.e. the user whose id is also the session's user_id.
      # The "@logged_in_user ||=" avoids unnecessary database queries that slow down the website.

      @logged_in_user ||= User.find_by_id(session[:user_id])
    end

    def logged_in? 
      # Returns true or false, depending on whether the user is logged in.
      # In other words, is there a current_user?

      !!current_user
    end

    def redirect_if_not_logged_in(action = "view this page")
      # This redirects users who try to do various actions (view a page, edit/delete a recipe, etc.) without being logged in.
      # By default, the error message is "You must be logged in to view this page."

      if !logged_in?
        flash[:error] = "You must be logged in to #{action}."
        redirect to "/users/login"
      end
    end

    def redirect_if_nonexistent(obj, obj_type)
      if !obj
        flash[:error] = "This #{obj_type} does not exist."
        redirect to "/recipes"
      end
    end

    def redirect_if_not_existing(obj, obj_type)
      if !obj
        flash[:error] = "This #{obj_type} does not exist."
        redirect to "/"
      end
    end
  end # End of helpers
end # End of ApplicationController
