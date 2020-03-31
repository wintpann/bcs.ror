class AddSumToAllEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :all_events, :sum, :integer, default: 0
    add_index :all_events, :event_type
  end
end
