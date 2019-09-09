class UsersController < ApplicationController
  get '/users/signup' do
    erb :"users/signup"
  end
end