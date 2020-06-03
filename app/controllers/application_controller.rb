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
      user = User.create(:username => params[:username], :password => params[:password])
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
    user = User.find_by(:username => params[:username])

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

  post "/account/deposit" do 
    user = User.find(session[:user_id])
    new_balance = user.balance + params[:deposit_amount].to_i

    user.update(balance: new_balance)

    redirect '/account'
  end 

  post "/account/withdrawal" do 
    user = User.find(session[:user_id])
    if user.balance >= params[:withdrawal_amount].to_i
      new_balance = user.balance - params[:withdrawal_amount].to_i

      user.update(balance: new_balance)

      redirect '/account'
    else 
      erb :insufficient_funds
    end 
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
