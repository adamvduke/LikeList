class ChangeLikeCaptionFromStringToText < ActiveRecord::Migration
  def up
    change_column :likes, :caption, :text, :limit => nil
  end
end
