require "./config/environment"
require "./app/models/user"
require "pry"

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
  	user = User.new(:username => params[:username], :password => params[:password])
    if params[:username] != "" && params[:password] != ""
		redirect "/login"
		else
		redirect "/failure"
    end
    #What the crap
    #IF !user.username OR !user.password THEN no password = goes to login / signup = goes to fail
    #IF user.username AND user.password THEN no username = goes to login
    #(also IF !!user.username AND !!user.password )
    #IF user.save THEN no username = goes to login 
    #IF !user.save THEN no password = goes to login / signup = goes to fail???
    #IF !!user.save THEN no username = goes to login
    #Okay that looks clumsy but it works.
  end

  get '/test' do
    erb :test
  end 

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
 
		if user && user.authenticate(params[:password])
		  session[:user_id] = user.id
		  redirect "/account"
		else
		  redirect "/failure"
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
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
