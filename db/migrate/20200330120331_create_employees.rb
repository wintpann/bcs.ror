class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.integer :fixed_rate, default: 0
      t.integer :interest_rate, default: 0
      t.boolean :working, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :employees, :name, unique: true
  end
end
