class ReportController < ApplicationController
  def index
    @employees = Employee.all

    @heello = Employment.joins(:employee, :payroll, :department).select("employees.id as id, CONCAT(employees.firstname, ' ', employees.lastname) AS name, employments.hire_date, employments.termination_date, employees.dob, employees.gender, departments.name AS department_name, payrolls.amount, payrolls.cycle")
    # @heello = Employment.joins(:payroll).select('*')
    # @heello = Department.joins(Employment)

    render json: @heello
  end
end
