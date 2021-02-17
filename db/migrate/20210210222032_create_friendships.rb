class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.integer :submitter_id, index:true
      t.integer :receiver_id, index:true
      t.boolean :status

      t.timestamps
    end
    add_foreign_key :friendships, :users, column: :submitter_id
    add_foreign_key :friendships, :users, column: :receiver_id
  end
end
