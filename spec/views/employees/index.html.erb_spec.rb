require 'rails_helper'

RSpec.describe 'employees/index', type: :view do
  before(:each) do
    assign(:employees, [
      Employee.create!(
        firstname: 'John',
        lastname: 'Doe',
        dob: '2000-01-01',
        gender: 'Male'
      ),
      Employee.create!(
        firstname: 'Tyler',
        lastname: 'Yeomans',
        dob: '1996-06-17',
        gender: 'Male'
      )
    ])
  end

  it "renders the employees index page" do
    render

    assert_select "p>span", text: 'John'.to_s, count: 1

    assert_select "p>span", text: 'Doe'.to_s, count: 1

    assert_select "p>span", text: '2000-01-01'.to_s, count: 1 

    assert_select "p>span", text: 'Male'.to_s, count: 2
  end
end