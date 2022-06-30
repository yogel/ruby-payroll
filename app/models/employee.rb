class Employee < ApplicationRecord
  # belongs_to :department
  # has_one :employment
  # has_one :payroll
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :dob, presence: true, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }
  validates :gender, presence: true
end
