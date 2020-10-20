class AddNameToChannel < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :name, :string
  end
end
