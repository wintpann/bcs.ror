class CreateThrowingEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :throwing_events do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :amount
      t.references :all_event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
