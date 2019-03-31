class SessionController < ApplicationController
  def new
  end

	def create
		@user = User.find_by name: params[:name]
		if !@user
			flash.now.alert = "username #{params[:name]} was invalid"
			render :index
		elsif @user.password == params[:password]
			session[:user] = @user.name
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
