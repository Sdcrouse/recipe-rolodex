require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "kookaburra_cockadoodle" # It sounded funny; what can I say?
  end

  get "/" do
    erb :index
  end

  helpers do
    def current_user
      # The user who is currently logged in, i.e. the user whose id is also the session's user_id.
      # The "@user ||=" avoids unnecessary database queries that slow down the website.

      @logged_in_user ||= User.find_by_id(session[:user_id])
    end

    def logged_in? 
      # Returns true or false, depending on whether the user is logged in.
      # In other words, is there a current_user?

      !!current_user
    end
  end
end
