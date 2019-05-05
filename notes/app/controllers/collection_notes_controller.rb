class CollectionNotesController < ApplicationController
  before_action :set_collection_notes, except: [:create, :destroy]

  def new
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to add a note to a collection"
    else
       @collection_notes = CollectionNote.new
    end
  end

  def create
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to add a note to a collection"
    else
       @collection = Collection.find(params[:collection])
       @note = Note.find(params[:note])
       @collection_note = CollectionNote.new(collection: @collection, note: @note)

       respond_to do |format|
       if @collection_note.save
          format.html { redirect_to notes_path, notice: 'Note successfully added.' }
       else
          format.html { redirect_to notes_path, notice: 'Note could not be added.' }
          format.json { render json: @collection_notes.errors, status: :unprocessable_entity }
       end
       end
    end
  end

  def destroy
    if !session[:user]
       redirect_to login_path, :alert => "You have to log in to remove a note to a collection"
    else
       @collection = Collection.find(params[:collection])
       @note = Note.find(params[:note])
       @collection_note = CollectionNote.find_by(collection: @collection, note: @note)

       @collection_note.destroy
       respond_to do |format|
       format.html { redirect_to collections_path, notice: 'Note successfully removed.' }
       format.json { head :no_content }
       end
    end 
  end

  private
    def set_collection_notes
      begin
        @collection_notes = CollectionNote.find(params[:id])
      rescue
        respond_to do |format|
        format.html { redirect_to root_path, notice: 'Collections note not found' }
        format.json { render json: @collection_notes.errors, status: :unprocessable_entity }
        end
      end
    end

    def collection_notes_params
      params.require(:collection_notes).permit(:collection, :note)
    end
end
