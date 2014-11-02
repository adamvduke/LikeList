class AddIndexsOnWebUrlAndCreatedAtToLikes < ActiveRecord::Migration
  def change
    add_index :likes, :web_url
    add_index :likes, :created_at
    add_index :likes, [:web_url, :created_at]
  end
end
