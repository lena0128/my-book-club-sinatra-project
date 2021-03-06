require 'rack-flash'

class ReviewsController < ApplicationController
  use Rack::Flash

     get '/reviews' do
        if_not_logged_in_then_redirect_to_login

        @reviews = Review.all
        erb :"/reviews/index"
      end

     get '/reviews/new' do
        if_not_logged_in_then_redirect_to_login

        erb :"/reviews/new"
      end

      get '/reviews/:id' do
        if logged_in?
          @review = Review.find(params[:id])
          id = @review.user_id
          @writer = User.find(id)
          erb :"/reviews/show"
        else
          redirect "/login"
        end
      end

      get '/reviews/:id/edit' do
        if_not_logged_in_then_redirect_to_login

        @review = Review.find(params["id"])
        
        if @review.user == current_user
          erb :"/reviews/edit"
        else
          flash[:message] = "ALERT: You are not allowed to edit other users' reviews! "
          redirect "/reviews"
        end
      end

      post '/reviews' do
        if_not_logged_in_then_redirect_to_login

        if !params[:book_title].empty? && !params[:rating].empty? && !params[:genres].empty? && !params[:content].empty? && !params[:thumbnail].empty?
          @review = Review.create(book_title: params[:book_title])
          @review.content = params[:content]
          @review.thumbnail = params[:thumbnail]
          @review.rating = params[:rating]
          @review.genre_ids = params[:genres]
          @review.user = current_user
          @review.save 
          flash[:message] = "Successfully created a review."
          redirect "/reviews/#{@review.id}"
        else
          redirect "/reviews/new"
        end
      end
        
        patch '/reviews/:id' do
          if logged_in?
            @review = Review.find(params[:id])
          end

          if params[:updated_book_title] != "" || params[:updated_content] != "" || params[:updated_thumbnail] != "" || params[:updated_rating] != "" || params[:updated_genres] != ""
            @review.book_title = params[:updated_book_title]
            @review.content = params[:updated_content]
            @review.thumbnail = params[:updated_thumbnail]
            @review.rating = params[:updated_rating]
            @review.genre_ids = params[:updated_genres]
            @review.save
          end 
          redirect "/reviews/#{@review.id}"
        end

        delete '/reviews/:id' do
          if_not_logged_in_then_redirect_to_login

          @review = Review.find(params["id"])
          if logged_in? && @review.user == current_user
            @review.delete
            flash[:message] = "Review successfully deleted."
            redirect "/reviews"
          else
            flash[:message] = "You are not allowed to delete other users' reviews."
             redirect "/login"
          end

        end

end