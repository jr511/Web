class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if session[:user]
		@users = User.all
      # redirect_to notes_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if !session[:user]
       redirect_to root_path, :alert => "You have to log in to view an user "
    else
       @users = User.find(params[:id]) 
       if @users.name != session[:user]
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
       redirect_to root_path, :alert => "You have to log in to edit an user"
    else
       @users = User.find(params[:id]) 
       if @users.name != session[:user] and !session[:admin]
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
          session[:user] = @user.name
          redirect_to root_url + 'notes', :notice => "Signed up!"
       else
          render :new
       end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if !session[:user]
       redirect_to root_path, :alert => "You have to log in to edit an user"
    else
       @users = User.find(params[:id]) 
       if @users.name != session[:user] and !session[:admin]
          redirect_to notes_path, :alert => "You cannot edit another user!"
       else
          respond_to do |format|
          if check_params[:password] != check_params[:confirm_password]
             format.html { redirect_to @user, notice: "Passwords don't match" }
             format.json { render json: @user.errors, status: :unprocessable_entity}
	  else
             if @user.update(user_params)
                session[:user] = user_params[:name]
                format.html { redirect_to @user, notice: 'User was successfully updated.' }
                format.json { render :show, status: :ok, location: @user }
             else
                format.html { render :edit }
                format.json { render json: @user.errors, status: :unprocessable_entity }
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
       redirect_to root_path, :alert => "You have to log in to delete an user"
    else
       @users = User.find(params[:id]) 
       if @users.name != session[:user]
          redirect_to notes_path, :alert => "You cannot delete another user!"
       else
          @user.destroy
          respond_to do |format|
	  session[:user] = nil
          format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
          format.json { head :no_content }
          end
       end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :confirm_admin)
    end

    def check_params
      params.require(:user).permit(:name, :password, :confirm_password, :confirm_admin)
    end
end
