class CreateStartWorkSessionEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :start_work_session_events do |t|
      t.references :all_event, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
