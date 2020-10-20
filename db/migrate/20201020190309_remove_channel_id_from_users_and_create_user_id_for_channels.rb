class RemoveChannelIdFromUsersAndCreateUserIdForChannels < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :channel_id, :integer
    add_column :channels, :user_id, :integer
  end
end
