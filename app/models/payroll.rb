class Payroll < ApplicationRecord
  has_one :employment
  validates :amount, presence: true, numericality: { only_integer: false, greater_than: 0 }
  validates :cycle, presence: true
end
