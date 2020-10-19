class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|

      t.integer :user_id
      t.text :emoji

    end
  end
end
