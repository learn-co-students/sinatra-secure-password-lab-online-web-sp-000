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
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      User.new(username: params[:username], password: params[:password]).save
      redirect '/login'
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
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password]) 
      session[:user_id] = user.id
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

  get '/insufficient' do
    @user = current_user
    erb :insufficient
  end

  post "/account" do
    @user = User.find(session[:user_id])
    puts params[:deposit]
    puts params[:withdrawal]
    if (@user.balance - params[:withdrawal].to_i) < 0
      redirect '/insufficient'
    else
      @user.balance += params[:deposit].to_i
      @user.balance -= params[:withdrawal].to_i
      @user.save
    end
    redirect '/account'
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
