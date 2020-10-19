class AddingMessageIdColumnToReactions < ActiveRecord::Migration[5.2]
  def change
    add_column :reactions, :message_id, :integer
  end
end
