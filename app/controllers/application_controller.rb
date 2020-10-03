require "./config/environment"
require "./app/models/user"
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
    #your code here
    user = User.new(:username => params[:username], :password => params[:password])

    if params[:password] != "" && params[:username] != "" #it neither username or pass is empty
      #can't do nil or !! because empty string is not nil. 
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      #apparently setting userid without : doesn't work
      #either symbol or string with " " around it
      redirect '/account'
    else
      redirect '/failure'
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
      # session[:user_id] retruns a value.
      # !sesson returns true if it doesnt exist (!session means session == nil, a comparison question)
      # !!session returns returns true if it does exist
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
