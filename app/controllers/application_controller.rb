require "./config/environment"
require "./app/models/user"
require 'pry'
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if params[:username] != "" && params[:password] != "" # checks to make sure that our username and password collected from our form is not an empty string.
      user = User.new(:username => params[:username], :password => params[:password])
      #binding.pry
      user.save
      session[:user_id] = user.id
      redirect "/login"
    else
      redirect "/failure"
    end
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    #binding.pry
    if user && user.authenticate(params[:password])
      #binding.pry
      session[:user_id] = user.id 
      redirect to "/account"
    else
      redirect "/failure"
    end
  end

  get '/account' do
    #binding.pry
    if logged_in?
      erb :account
    else  
      redirect "/"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in? # returns true or false based on the presence of a session[:user_id]
      !!session[:user_id]
    end

    def current_user # returns the instance of the logged in user, based on the session[:user_id]
      User.find(session[:user_id])
    end
  end

end
