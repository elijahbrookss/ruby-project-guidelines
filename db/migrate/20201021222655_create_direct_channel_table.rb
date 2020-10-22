class CreateDirectChannelTable < ActiveRecord::Migration[5.2]
  def change
    create_table :direct_channels do |t|
      t.string "name"
      t.integer "user1"
      t.integer "user2"
    end
  end
end
