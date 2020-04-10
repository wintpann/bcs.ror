class AddEmployeeIdToAllEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :all_events, :employee_id, :bigint, default: -1
  end
end
