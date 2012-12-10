class AddUniqeIndexUserIdToLikes < ActiveRecord::Migration
  def change
    add_index :likes, [:user_id, :ig_id], unique:true
  end
end
