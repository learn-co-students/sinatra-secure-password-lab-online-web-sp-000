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
    #your code here
    user = User.new(username: params[:username], password: params[:password], balance: 0.0)
    if params[:username] != "" && user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  post '/account/deposit' do 
    @user = User.find(session[:user_id])
    @user.desposit(params[:deposit])
    @user.update(balance: @user.balance)
    erb :deposit
  end

  post '/account/withdraw' do 
    @user = User.find(session[:user_id])
    success = @user.withdraw(params[:withdraw])
    if success
      @user.update(balance: @user.balance)
      erb :withdraw
    else
      redirect '/failure'
    end
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

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
