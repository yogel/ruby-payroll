class Payroll < ApplicationRecord
  # belongs_to :employee
  validates :amount, presence: true, numericality: { only_integer: false, greater_than: 0 }
  validates :cycle, presence: true
end
