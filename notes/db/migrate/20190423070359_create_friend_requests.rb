class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests do |t|
      t.references :user, foreign_key: {to_table: :users, on_delete: :cascade}, null: false
      t.references :friend, foreign_key: {to_table: :users, on_delete: :cascade}, null: false

      t.timestamps
    end
  end
end
