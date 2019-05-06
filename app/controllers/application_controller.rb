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
    # 1ST ATTEMPT
    # user = User.new(username: params[:username], password: params[:password])
    # if user.save
    #     redirect "/login"
    # else
    #     redirect "/failure"
    # end

    # 2ND ATTEMPT
    # if params[:username] == nil || params[:password_digest] == nil
    #     redirect "/failure"
    # else
    #     User.create(username: params[:username], password: params[:password])
    #     redirect '/login'
    # end

    # SOLLUTION
    if params[:username] == "" || params[:password] == ""
        redirect '/failure'
    else
        User.create(username: params[:username], password: params[:password])
        redirect '/login'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])

    erb :account
  end


  get "/account/deposit" do
      erb :deposit
  end

  post "/account/deposit" do
      # 1ST ATTEMPT
      # update params balance with user input
      # @user = User.update(balance: params[:balance])
      # add user input to balance in db
      # @user.balance += params[:balance]
      # redirect to account page
      # redirect "/account"

      # 2ND ATTEMPT
      # amount += params[:balance].to_f
      # @user.update(amount)
      # @user.save
      # redirect "/account"

      # 3RD ATTEMPT
      # if params[:balance] != nil
      #     user = User.find_by(params[:id])
      #     user.deposit(params[:balance])
      #     redirect "/account"
      # else
      #     redirect "/failure"
      # end

      # 4TH ATTEMPT
      @user = User.find(session[:user_id])
      # @user.balance += params[:balance]
      @user.update(balance: params[:balance])
      redirect "/account"
  end


  # binding.pry

  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    user = User.find_by(username: params[:username])

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

  # binding.pry

end
