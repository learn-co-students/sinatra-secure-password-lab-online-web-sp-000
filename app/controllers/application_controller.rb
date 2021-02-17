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
    user = User.new(username: params[:username], password: params[:password], balance: 0.0)

    if user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = current_user
    puts "Account Balance: #{@user.balance}"

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

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

  post "/account/deposit" do
    deposit = params[:deposit].to_i
    @user = current_user
    @user.password = params[:password]
    @user.balance += deposit
    @user.save
    redirect '/account'
  end

  post "/account/withdraw" do
    withdraw = params[:withdraw].to_i
    @user = current_user
    @user.password = params[:password]
    if @user.balance - withdraw > 0
      puts "Withdrawing: #{withdraw}"
      @user.balance -= withdraw
      @user.save
      redirect '/account'
    else
      puts "Failed to withdraw"
      redirect '/failure'
    end
  end

end
