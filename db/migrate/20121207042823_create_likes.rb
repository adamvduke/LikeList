class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.string :caption
      t.string :ig_id
      t.string :low_res_image
      t.string :standard_res_image
      t.string :thubmbnail
      t.string :web_url
      t.string :created_time
      t.string :filter
      t.string :username
      t.references :user

      t.timestamps
    end
    add_index :likes, :user_id
  end
end
