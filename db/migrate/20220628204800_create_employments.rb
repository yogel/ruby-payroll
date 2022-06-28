class CreateEmployments < ActiveRecord::Migration[7.0]
  def change
    create_table :employments do |t|
      t.date :hire_date
      t.date :termination_date
      t.integer :department_id
      t.integer :employee_id
      t.integer :payroll_id

      t.timestamps
    end
    add_index :employments, :department_id
    add_index :employments, :employee_id
    add_index :employments, :payroll_id
  end
end
