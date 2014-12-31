class AddUniqueConstraintsOnProviderFields < ActiveRecord::Migration
  def change
    add_index :users, :nickname, unique: true
    add_index :users, [:provider, :uid], unique: true
  end
end
