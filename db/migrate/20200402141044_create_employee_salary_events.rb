class CreateEmployeeSalaryEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :employee_salary_events do |t|
      t.references :all_event, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.integer :sum

      t.timestamps
    end
  end
end
