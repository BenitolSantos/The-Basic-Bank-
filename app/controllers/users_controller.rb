class UsersController < ApplicationController
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }

  #sinatra study groups tuesday - friday next week
  #you can simplify it by removing profiles - amelie

  get '/signup' do
     erb :"users/create_user"
  end

  post '/signup' do
    if params[:username] == "" || params[:password] == "" || params[:email] == ""
      redirect to ('/signup')
    else
      if params[:balance] == ""
        params[:balance] = 0
      end
      @user = User.create(username: params[:username], password: params[:password], email: params[:email], balance: params[:balance])
      @user.save
      session[:user_id] = @user.id

      redirect to ("/transactions")
    end
  end

  get '/login' do
    if !logged_in?
      erb :"users/login"
    else
      redirect to ('/transactions')
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id

      redirect "/transactions"
    else
      redirect to '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to ('/login')
    else
      redirect to ('/login')
    end
  end

  get '/users/:slug' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      redirect "/transactions"
    else
      redirect to '/signup'
    end
  end
end
