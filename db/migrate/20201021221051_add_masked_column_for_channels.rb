class AddMaskedColumnForChannels < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :masked, :boolean
  end
end
