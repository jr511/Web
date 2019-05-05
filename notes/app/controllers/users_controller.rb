class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to view users"
    else
      if !session[:admin]
         redirect_to root_path
      else
         @users = User.all
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to view an user "
    else
       @user = User.find(params[:id]) 
       if @user.name != session[:user] and !session[:admin]
          redirect_to notes_path, :alert => "You cannot view another user!"
       end
    end
  end

  # GET /users/new
  def new
    if session[:user]
       redirect_to notes_path
    end
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to edit an user"
    else
       @user = User.find(params[:id]) 
       if @user.name != session[:user] and !session[:admin]
          redirect_to notes_path, :alert => "You cannot edit another user!"
       end
    end
  end

  # POST /users
  # POST /users.json
  def create
    if check_params[:password] != check_params[:confirm_password]
       redirect_to signup_path, :alert => "Passwords don't match!"
    else
       @user = User.new(user_params)
       if @user.save
          session[:id] = @user.id
          session[:user] = @user.name
	  session[:admin] = @user.admin
          redirect_to root_url + 'notes', :notice => "Signed up!"
       else
          redirect_to signup_path, :alert => "User name already in use"
       end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to edit an user"
    else
       @user = User.find(params[:id]) 
       if @user.name != session[:user] and !session[:admin]
          redirect_to notes_path, :alert => "You cannot edit another user!"
       else
	  respond_to do |format|
          if check_params[:password] != check_params[:confirm_password]
	     @update = false
             format.html { redirect_to edit_user_path(@user), notice: "Passwords don't match" }
	     format.json { render json: @user.errors, status: :unprocessable_entity}
	  else
  	     if @user.name == session[:user]
                if @user.update(user_params)        
	           session[:user] = @user.name
                   session[:admin] = @user.admin
	           format.html { redirect_to @user, notice: 'User was successfully updated.' }
             	   format.json { render :show, status: :ok, location: @user }
		else
		   format.html { render action: 'edit' }
                   format.json { render json: @user.errors, status: :unprocessable_entity }
		end
	     else
                if @user.update(user_params)        
                   format.html { redirect_to @user, notice: 'User was successfully updated.' }
                   format.json { render :show, status: :ok, location: @user }
		else
                   format.html { render action: 'edit' }
                   format.json { render json: @user.errors, status: :unprocessable_entity }
		end
	     end             
          end
	  end
       end
     end
   end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to delete an user"
    else
       @user = User.find(params[:id]) 
       if @user.name != session[:user] and !session[:admin]
          redirect_to notes_path, :alert => "You cannot delete another user!"
       else
	  if @user.name == session[:user]
 	     session[:id] = nil
	     session[:user] = nil
	     session[:admin] = nil         
	  end
	  @user.destroy
          respond_to do |format|
	  format.html { redirect_to root_url, notice: 'User was successfully destroyed.' }
          format.json { head :no_content }
	  end
       end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin
        @user = User.find(params[:id])
      rescue
        respond_to do |format|
        format.html { redirect_to root_path, notice: 'User not found' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :admin)
    end

    def check_params
      params.require(:user).permit(:name, :password, :confirm_password, :admin)
    end
end
