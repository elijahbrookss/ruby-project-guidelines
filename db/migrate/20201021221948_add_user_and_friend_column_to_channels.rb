class AddUserAndFriendColumnToChannels < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :user_id, :integer
    add_column :channels, :friend_id, :integer
  end
end
