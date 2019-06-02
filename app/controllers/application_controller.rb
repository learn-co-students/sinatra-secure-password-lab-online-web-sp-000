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
    user = User.new(username: params[:username], password: params[:password])
    if user.username.length > 0 && user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  post '/account' do
    @user = current_user
    #binding.pry
    if params[:add_value].length > 0
      @user.balance += params[:add_value].to_f
      @user.save
    end
    if params[:withdraw].length > 0
      if params[:withdraw].to_f <= @user.balance
        @user.balance -= params[:withdraw].to_f
        @user.save
      else
        redirect '/withdraw_failure'
      end
    end
    redirect '/account'
  end

  get '/withdraw_failure' do
    erb :withdraw_failure
  end


  get "/login" do
    erb :login
  end

  post "/login" do
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
