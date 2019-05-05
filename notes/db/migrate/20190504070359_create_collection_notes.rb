class CreateCollectionNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_notes do |t|
      t.references :collection, foreign_key: {to_table: :collections, on_delete: :cascade}, null: false
      t.references :note, foreign_key: {to_table: :notes, on_delete: :cascade}, null: false

      t.timestamps
    end
  end
end
