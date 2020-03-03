require "./config/environment"
require "./app/models/user"

class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    use Rack::Flash, :sweep => true
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    @user = User.new(username: params["username"], password: params["password"], balance: 0)
    if @user.save
      session[:user_id] = @user.id
      redirect '/login'
    else
      redirect "/failure"
    end
  end

  


  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/account"
    else
      redirect to "/failure"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  post "/deposit" do
    @user = User.find(session[:user_id])
    @user.balance += params[:deposit_amount].to_i
    @user.save
    flash[:notice] = "Thanks for the deposit"
    redirect "/account"
  end

  post "/withdrawal" do
    @user = User.find(session[:user_id])
    if (params[:withdrawal_amount].to_i <= @user.balance)
      @user.balance -= params[:withdrawal_amount].to_i
      @user.save
    else
      flash[:error] = "Insufficient funds"
    end
    redirect "/account"
  end

  get '/account' do
    @user = User.find(session[:user_id])
    if logged_in?
      erb :account
    else
      redirect '/login'
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
