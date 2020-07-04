require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

#Renders an index.erb file with links to login or signup:
  get "/" do
    erb :index
  end

#Renders a form to create a new user:
  get "/signup" do
    erb :signup
  end

#Includes fields for username and password:
#make a new instance of user class w/ username and pass from params.
  post "/signup" do
    if params[:username]=="" || params[:password]==""
       redirect to '/failure'
     end
     user = User.new(:username => params[:username], :password => params[:password])
     if user.save
 			redirect to "/login"
 		else
 			redirect to "/failure"
 		end
   end

#Renders an account.erb page which displays once user is logged in:
  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

#Login form:
  get "/login" do
    erb :login
  end

#find the user by username.
#IS THE USER AUTHENTICATED? if yes, set session user id to redirect to account
#if not, failure, try again
#did we find the user by that username? success or failure? success = account
  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
    	session[:user_id] = user.id
    	redirect "/account"
    else
    	redirect "/failure"
    end
  end

#Renders failure.erb
  get "/failure" do
    erb :failure
  end

#clears the session data, redirects to home page:
  get "/logout" do
    session.clear
    redirect "/"
  end

#Helper methods: add logic to our views
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
