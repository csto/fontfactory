class AddUserIdToFonts < ActiveRecord::Migration
  def change
    add_reference :fonts, :user, index: true
  end
end
