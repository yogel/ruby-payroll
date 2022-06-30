class Employment < ApplicationRecord
  belongs_to :employee
  belongs_to :payroll
  belongs_to :department

  validates :hire_date, presence: true, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }
  validates :department_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :employee_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :payroll_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
