class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price_in
      t.integer :price_out
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :products, :name, unique: true
  end
end
