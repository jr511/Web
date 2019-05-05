class CreateCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :collections do |t|
      t.string :title, null: false
      t.references :user, foreign_key: {to_table: :users, on_delete: :cascade}, null: false
      t.boolean :shared, null: false      

      t.timestamps
    end
  end
end
