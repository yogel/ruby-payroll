require 'rails_helper'

RSpec.describe Employee, type: :model do
  it 'has a firstname' do
    employee = Employee.new(firstname: 'John')
    expect(employee.firstname).to eq('John')
  end

  it 'has to have a valid firstname' do
    employee = Employee.new(firstname: '')
    expect(employee).to_not be_valid
  end
end
