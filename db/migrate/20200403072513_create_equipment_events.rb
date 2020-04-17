class CreateEquipmentEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :equipment_events do |t|
      t.references :all_event, null: false, foreign_key: true
      t.string :description, default: 'Без описания'
      t.integer :sum

      t.timestamps
    end
  end
end
