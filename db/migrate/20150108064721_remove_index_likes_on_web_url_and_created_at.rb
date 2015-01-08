class RemoveIndexLikesOnWebUrlAndCreatedAt < ActiveRecord::Migration
  def change
    remove_index :likes, [:web_url, :created_at]
  end
end
