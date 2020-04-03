class CreateOtherExpenseEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :other_expense_events do |t|
      t.references :all_event, null: false, foreign_key: true
      t.string :description
      t.integer :sum

      t.timestamps
    end
  end
end
