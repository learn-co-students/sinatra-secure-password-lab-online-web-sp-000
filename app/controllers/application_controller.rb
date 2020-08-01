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
    user = User.new( :username => params[:username], :password => params[:password])
    if user.save
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
    user = User.find_by(:username => params[:username])

    if user && !! params[:password] && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect to("/failure")
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  post '/deposit' do
    user = User.find(session[:user_id])
    if logged_in?
      new_balance = user.balance + params[:deposit_amount].to_f
      user.update(:balance => new_balance)
      redirect '/account'
    else
      redirect '/failure'
    end    
  end

  post '/withdraw' do
    user = User.find(session[:user_id])
    if logged_in? && user.balance > params[:withdrawal_amount].to_f
      new_balance = user.balance - params[:withdrawal_amount].to_f
      user.update(:balance => new_balance)
      redirect '/account'
    else
      redirect '/failure'
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
