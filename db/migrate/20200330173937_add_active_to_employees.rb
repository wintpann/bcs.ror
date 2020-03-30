class AddActiveToEmployees < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :active, :boolean, default: true
  end
end
