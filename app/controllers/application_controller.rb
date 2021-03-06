require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') 
  end

  get "/" do
    @review = Review.last
    id = @review.user_id
    @user = User.find(id)
    erb :index
  end

  helpers do
     
    def if_not_logged_in_then_redirect_to_login
      if !logged_in?
      flash[:message] = "Please login first."
      redirect "/login"
      end
    end

    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

end
