class RemoveUserAndFriendColumnFromChannels < ActiveRecord::Migration[5.2]
  def change
    remove_column :channels, :user_id, :integer
    remove_column :channels, :friend_id, :integer
  end
end
