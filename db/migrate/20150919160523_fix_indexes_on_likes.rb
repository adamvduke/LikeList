class FixIndexesOnLikes < ActiveRecord::Migration
  def change
    remove_index :likes, :web_url
    add_index :likes, :web_url, where: "web_url IS NOT NULL"
  end
end
