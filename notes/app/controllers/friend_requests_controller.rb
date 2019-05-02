# app/controllers/friend_requests_controller.rb
class FriendRequestsController < ApplicationController
  before_action :set_friend_request, except: [:index, :create]
  
  def index
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to view friend requests"
    else
       @current_user = User.find(session[:id])
       @users = User.all
       @friends = Friendship.all
       @friend_request = FriendRequest.all
       @incoming = FriendRequest.where(friend: @current_user)
       @outgoing = @current_user.friend_requests
    end
  end

  def show
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to view friend requests"
    else
       @friend_request = FriendRequest.all
    end
  end

  def new
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to send a friend request"
    else
       @friend_request = FrirnedRequest.new
    end
  end

  def create
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to send a friend request"
    else
       @user = User.find(params[:user])
       @friend = User.find(params[:friend])
       @friend_request = FriendRequest.new(user: @user, friend: @friend)

       respond_to do |format|
       if @friend_request.save
          format.html { redirect_to friends_index_path, notice: 'Friend request successfully sent.' }
       else
          format.html { redirect_to friends_index_path, notice: 'Friend request could not be sent.' }
          format.json { render json: @friend_request.errors, status: :unprocessable_entity }
       end
       end
    end
  end

  def destroy
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to cancel a friend request"
    else
       @friend_request.destroy
       respond_to do |format|
       format.html { redirect_to friends_index_path, notice: 'Friend request was successfully destroyed.' }
       format.json { head :no_content }
       end
    end 
  end

  private
    def set_friend_request
      @friend_request = FriendRequest.find(params[:id])
    end

    def friend_params
      params.require(:friend_request).permit(:user, :friend)
    end
end

