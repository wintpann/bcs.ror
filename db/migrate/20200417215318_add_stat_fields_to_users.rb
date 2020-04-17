class AddStatFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :earned, :bigint, default: 0
    add_column :users, :throwed, :bigint, default: 0
  end
end
