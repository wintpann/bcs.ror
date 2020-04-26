class AddTimezoneToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :timezone, :float, default: 0
  end
end
