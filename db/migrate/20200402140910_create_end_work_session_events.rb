class CreateEndWorkSessionEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :end_work_session_events do |t|
      t.references :all_event, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
