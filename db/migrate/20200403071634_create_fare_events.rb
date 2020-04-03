class CreateFareEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :fare_events do |t|
      t.references :all_event, null: false, foreign_key: true
      t.string :description, default: ''
      t.integer :sum

      t.timestamps
    end
  end
end
