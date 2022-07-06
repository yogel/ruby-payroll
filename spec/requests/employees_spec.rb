require 'rails_helper'

RSpec.describe 'employees/index', type: :request do
  let(:valid_attributes) {
    {
      firstname: 'John',
      lastname: 'Doe',
      dob: '2000-01-01',
      gender: 'Male'
    }
  }

  let(:valid_post_attributes) {
    {
      firstname: 'John',
      lastname: 'Doe',
      dob: '2000-01-01',
      gender: 'Male',
      payroll_attributes: {
        amount: 123,
        cycle: 'Weekly'
      },
      employment_attributes: {
        department_id: Department.first.id, 
        hire_date: '2020-01-01',
        termination_date: nil
      }
    }
  }


  describe "GET /employees" do
    it "renders the index page" do
      get employees_path
      expect(response).to have_http_status(:success)
    end

    it "renders a successful response with an employee" do
      Employee.create! valid_attributes
      get employees_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /employees/new" do
    it "renders the new page" do
      get new_employee_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /employees" do
    context "with valid params" do
      it "creates a new Employee" do
        expect {
          post employees_path, params: { employee: valid_post_attributes }
        }.to change(Employee, :count).by(1)
      end
    end
  end
end