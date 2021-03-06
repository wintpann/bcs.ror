class CreateGivingEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :giving_events do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :amount
      t.references :employee, null: false, foreign_key: true
      t.references :all_event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
