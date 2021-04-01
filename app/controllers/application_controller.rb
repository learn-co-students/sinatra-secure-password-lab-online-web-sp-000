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

  		if user.save && user.username != ''
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
    ##your code here
    user = User.find_by(:username => params[:username])
  		if user && user.authenticate(params[:password])
		  session[:user_id] = user.id
  		  redirect "/account"
  		else
  		  redirect "/failure"
  		end
  end

  get '/account' do
    @user = current_user
    erb :account
  end

  get '/deposit' do 
    @user = current_user
    erb :deposit
  end

  post '/deposit' do 
    @user = current_user
    @user.deposit(params[:deposit].to_f)
    @user.save
    redirect '/account'
  end


  get '/withdraw' do 
    @user = current_user
    erb :withdraw
  end

  post '/withdraw' do 
    @user = current_user
    if @user.balance - params[:withdraw].to_f < 0.00
      redirect '/withdraw_error'
    else
      @user.withdraw(params[:withdraw].to_f)
      @user.save
      redirect '/accounts'
    end
  end

  get '/withdraw_error' do 
    @user = current_user
    erb :withdraw_error
  end

  post '/withdraw_error' do 
    @user = current_user
    if @user.balance - params[:withdraw].to_f < 0.00
      redirect '/withdraw_error'
    else
      @user.withdrawal(params[:withdraw].to_f)
      @user.save
      redirect '/account'
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

  