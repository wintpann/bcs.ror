class CreateAllEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :all_events do |t|
      t.string :event_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
