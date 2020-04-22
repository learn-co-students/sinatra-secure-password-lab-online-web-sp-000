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
      user = User.new(:username => params[:username], :password => params[:password])
      if params[:initial_deposit] == ""
        user.balance = 0.0
      else
        user.balance = params[:initial_deposit].to_f
      end
      user.save
      redirect '/login'
    end

  end

  get '/account' do
    @user = current_user
    erb :account
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

  patch '/balance/edit/withdraw' do
    user = current_user
    if user.balance < params[:withdraw_amount].to_f
      redirect '/overdraft'
    else
      new_balance = user.balance - params[:withdraw_amount].to_f
      user.update(balance: new_balance)
      redirect '/account'
    end
  end

  patch '/balance/edit/deposit' do
    deposit_amount = params[:deposit_amount].to_f + current_user.balance
    current_user.update(balance: deposit_amount)
    redirect '/account'
  end

  get '/overdraft' do
    erb :overdraft
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
