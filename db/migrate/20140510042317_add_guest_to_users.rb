class AddGuestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :guest, :boolean
    add_index :users, :guest
  end
end
