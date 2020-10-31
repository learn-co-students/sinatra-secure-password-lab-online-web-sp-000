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
      redirect to '/failure'
    else
      User.create(:username => params[:username], :password => params[:password], :balance => 0.00)
      redirect to '/login'
    end
  end

  get '/account' do
    #binding.pry
    @user = User.find(session[:user_id])
    erb :account
  end

  #withdrawls and deposits
  post '/account' do
    @user = User.find(session[:user_id])
    #binding.pry
    if params[:withdrawl] && @user.balance >= params[:withdrawl].to_f
      #binding.pry
      @user.balance = @user.balance - params[:withdrawl].to_f
      @user.save
      redirect to '/account'
    elsif params[:deposit]
      @user.balance = @user.balance + params[:deposit].to_f
      @user.save
      #binding.pry
      redirect to '/account'
    else
      redirect to '/failure'
    end
  end



  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    @user = User.find_by(:username => params[:username])
    if @user != nil && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/account'
    else
      redirect to '/failure'
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
