class FriendsController < ApplicationController

  def index
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to view friends"
    else
       @current_user = User.find(session[:id])
       @users = User.all
       @friends = Friendship.all
       @friend_request = FriendRequest.all
    end
  end

  def create
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to accept a friend request"
    else
       @user = User.find(params[:user])
       @friend = User.find(params[:friend])
       @friends = Friendship.new(user: @user, friend: @friend)

       respond_to do |format|
       if @friends.save
          @friend_request = FriendRequest.find(params[:id])
          @friend_request.destroy
          format.html { redirect_to friends_index_path, notice: 'Friend request accepted.' }
       else
          format.html { redirect_to friends_index_path, notice: 'Friend request could not be accepted.' }
          format.json { render json: @friend_request.errors, status: :unprocessable_entity }
       end
       end
     end
  end

  def destroy
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to refuse a friend request"
    else
       @friend = Friendship.find(params[:friend])
       @friend.destroy
       respond_to do |format|
       format.html { redirect_to friends_index_path, notice: 'Friendship was successfully destroyed.' }
       format.json { head :no_content }
       end 
    end
  end

private
 
   def set_friend
      @friend = @current_user.friends.find(params[:id])
   end
end
