class Employee < ApplicationRecord
  has_one :employment
  has_one :payroll, through: :employment
  has_one :department, through: :employment
  accepts_nested_attributes_for :employment, :payroll, allow_destroy: true

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :dob, presence: true, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }
  validates :gender, presence: true
end
