class AddLastSignInToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.timestamp :last_sign_in
    end
  end
end
