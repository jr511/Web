class SessionController < ApplicationController
  def index
      if session[:user]
         redirect_to notes_path
      end
  end

  def create
      @user = User.find_by name: params[:name]
      if !@user
	 flash.now.alert = "username #{params[:name]} was invalid"
	 render :index
      elsif @user.password == params[:password]
	 session[:user] = @user.name
	 session[:admin] = @user.admin
	 redirect_to root_url + 'notes', :notice => "Logged in!" 
      else
	 flash.now.alert = "password was invalid"
	 render :index
      end
  end

  def destroy
      session[:user] = nil
      redirect_to :root, :notice => "Logged out!"
  end
end
