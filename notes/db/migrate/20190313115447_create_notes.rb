class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.string :content
      t.string :image
      t.references :user, foreign_key: {to_table: :users, on_delete: :cascade}, null: false
      t.boolean :shared, null: false      

      t.timestamps
    end
      add_attachment :notes,:cover
  end
end
