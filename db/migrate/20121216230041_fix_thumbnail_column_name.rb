class FixThumbnailColumnName < ActiveRecord::Migration
  def up
    rename_column :likes, :thubmbnail, :thumbnail
  end

  def down
  end
end
