class AddChannelIdToDirectChannels < ActiveRecord::Migration[5.2]
  def change
    add_column :direct_channels, :channel_id, :integer
  end
end
