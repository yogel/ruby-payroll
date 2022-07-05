class Department < ApplicationRecord
  has_many :employments
  validates :name, presence: true, uniqueness: true
end
