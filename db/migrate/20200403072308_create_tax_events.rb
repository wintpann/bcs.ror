class CreateTaxEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :tax_events do |t|
      t.references :all_event, null: false, foreign_key: true
      t.string :description, default: 'No description'
      t.integer :sum

      t.timestamps
    end
  end
end
