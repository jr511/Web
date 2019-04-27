class FriendsController < ApplicationController

  def index
    @current_user = User.find(session[:id])
    @users = User.all
    @friends = Friendship.all
    @friend_request = FriendRequest.all
  end

  def create
    @user = User.find(params[:user])
    @friend = User.find(params[:friend])
    @friends = Friendship.new(user: @user, friend: @friend)

    respond_to do |format|
    if @friends.save
print('--------------------------------------------------------')
print('Added')
      @friend_request = FriendRequest.find(params[:id])
      @friend_request.destroy
      format.html { redirect_to friends_index_path, notice: 'Friend request accepted.' }
    else
      format.html { redirect_to friends_index_path, notice: 'Friend request could not be accepted.' }
      format.json { render json: @friend_request.errors, status: :unprocessable_entity }
    end
    end
  end

  def destroy
     @friend = Friendship.find(params[:friend])
     @friend.destroy
     respond_to do |format|
     format.html { redirect_to friends_index_path, notice: 'Friendship was successfully destroyed.' }
     format.json { head :no_content }
     end 
  end

private
 
   def set_friend
      @friend = @current_user.friends.find(params[:id])
   end
end
