class UsersController < ApplicationController
  get '/users/signup' do
    erb :"users/signup"
  end

  post '/users' do
    "You have made a new user!"
  end
end