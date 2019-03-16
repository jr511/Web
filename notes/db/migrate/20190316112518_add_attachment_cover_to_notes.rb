class AddAttachmentCoverToNotes < ActiveRecord::Migration[5.2]
  def self.up
    change_table :notes do |t|
      t.attachment :cover
    end
  end

  def self.down
    remove_attachment :notes, :cover
  end
end
