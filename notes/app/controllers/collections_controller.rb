class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]

  def index
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to view collections"
    else
       @collections = Collection.all
       @notes = Note.all
       @users = User.all
       @friends = Friendship.all 
    end
  end

  def notes
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to view collection's notes"
    else
       @collection = Collection.find(params[:id])
       @notes = Note.all
       @collection_notes = CollectionNote.all
    end
  end

  def show
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to view a collection "
    else
       @view = true
       @collection = Collection.find(params[:id])
       @friend = Friendship.all
       if @collection.user.name != session[:user] and !session[:admin] 
	  @view = false
          for @user in @friend
	      if @user.user_id == session[:id]
	      if @collection.user.id == @user.friend_id and @collection.shared
		 @view = true
	      end
	      end
	  end
       end
       if !@view
          redirect_to collections_path, :alert => "You cannot view another user’s collection!"
       end
    end
  end

  def new
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to create a collection "
    else
       @collection = Collection.new
    end
  end

  def edit
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to edit a collection "
    else
       @view = true
       @collection = Collection.find(params[:id])
       @friend = Friendship.all
       if @collection.user.name != session[:user] and !session[:admin]
          @view = false
          for @user in @friend
	      if @user.user_id == session[:id]
	      if @collection.user.id == @user.friend_id and @collection.shared
		 @view = true
	      end
	      end
	  end
       end
       if !@view
          redirect_to collections_path, :alert => "You cannot edit another user’s collection!"
       end
    end
  end

  def create
      if !session[:user]
         redirect_to login_path, :alert => "You have to log in to create a collection "
      else
         @collection = Collection.new(collection_params)
         if !session[:admin]
            @collection.user = User.find_by name: session[:user]
         end
         respond_to do |format|
         if @collection.save
            format.html { redirect_to collections_url, notice: 'Collection was successfully created.' }
            format.json { render action: 'show', status: :created, location: @collection }
         else
            format.html { render action: 'new' }
            format.json { render json: @collection.errors, status: :unprocessable_entity }
         end
         end
     end
  end

  def update
      if !session[:user]
         redirect_to login_path, :alert => "You have to log in to edit a collection "
      else
         respond_to do |format|
         if @collection.update(collection_params)
            format.html { redirect_to collections_path, notice: 'Collection was successfully updated.' }
            format.json { head :no_content }
         else
            format.html { render action: 'edit' }
            format.json { render json: @collection.errors, status: :unprocessable_entity }
         end
         end
       end
  end

  def destroy
      if !session[:user]
         redirect_to login_path, :alert => "You have to log in to delete a collection "
      else
         if @collection.user.name != session[:user] and !session[:admin]
            redirect_to collections_path, :alert => "You cannot delete another user’s collection!"
         else
            @collection.destroy
            respond_to do |format|
            format.html { redirect_to collections_url, notice: 'Collection was successfully destroyed.' }
            format.json { head :no_content }
            end
         end
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      begin
        @collection = Collection.find(params[:id])
      rescue
        respond_to do |format|
        format.html { redirect_to root_path, notice: 'Collection not found' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:title, :user_id, :shared )
    end
end
