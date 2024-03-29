require "#{Rails.root}/lib/services/my_service"

class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]

  def initialize
    super

    @payroll_event_stream = Services::EventStream.new('payroll')
  end

  # GET /employees or /employees.json
  def index
    @employees = Employee.all
  end

  # GET /employees/1 or /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
    @employee.employment = Employment.new
    @employee.payroll = Payroll.new
    @departments = Department.all
  end

  # GET /employees/1/edit
  def edit
    @employment = @employee.employment
    @payroll = @employee.payroll

    @departments = Department.all
  end

  # POST /employees or /employees.json
  def create
    ActiveRecord::Base.transaction do
      @departments = Department.all
      @payroll = Payroll.new({ "amount": employee_params[:payroll_attributes][:amount], "cycle": employee_params[:payroll_attributes][:cycle] })
      @employee = Employee.new({ "firstname": employee_params[:firstname], lastname: employee_params[:lastname], dob: employee_params[:dob], gender: employee_params[:gender] })

      payroll_worked = @payroll.save
      employee_worked = @employee.save

      @employment = Employment.new({ "department_id": employee_params[:employment_attributes][:department_id], hire_date: employee_params[:employment_attributes][:hire_date], termination_date: employee_params[:employment_attributes][:termination_date] })

      @employment.employee_id = @employee.id
      @employment.payroll_id = @payroll.id
      employment_worked = @employment.save

      respond_to do |format|
        if employee_worked && employment_worked && payroll_worked
          format.html { redirect_to employee_url(@employee), notice: "Employee was successfully created." }
          format.json { render :show, status: :created, location: @employee }

          @payroll_event_stream.emitEvent({
            type: 'employee-created',
            payload: {
              employee: @employee.as_json(only: [:id, :firstname, :lastname, :dob, :gender]),
              employment: @employment.as_json(only: [:id, :department_id, :hire_date, :termination_date, ]),
              payroll: @payroll.as_json(only: [:amount, :cycle])
            }
          })
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    ActiveRecord::Base.transaction do
      @departments = Department.all

      update_employee = @employee.update({ "firstname": employee_params[:firstname], lastname: employee_params[:lastname], dob: employee_params[:dob], gender: employee_params[:gender] })

      update_employment = @employee.employment.update({ "department_id": employee_params[:employment_attributes][:department_id], hire_date: employee_params[:employment_attributes][:hire_date], termination_date: employee_params[:employment_attributes][:termination_date], department_id: employee_params[:employment_attributes][:department_id] })

      update_payroll = @employee.payroll.update({ "amount": employee_params[:payroll_attributes][:amount], "cycle": employee_params[:payroll_attributes][:cycle] })

      respond_to do |format|
        if
          format.html { redirect_to employee_url(@employee), notice: "Employee was successfully updated." }
          format.json { render :show, status: :ok, location: @employee }

          @payroll_event_stream.emitEvent({
            type: 'employee-updated',
            payload: {
              employee: @employee.as_json(only: [:id, :firstname, :lastname, :dob, :gender]),
              employment: @employment.as_json(only: [:id, :department_id, :hire_date, :termination_date, ]),
              payroll: @payroll.as_json(only: [:amount, :cycle])
            }
          })
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_url, notice: "Employee was successfully destroyed." }
      format.json { head :no_content }

      @payroll_event_stream.emitEvent({
        type: 'employee-deleted',
        payload: {
          employee: @employee.as_json(only: [:id, :firstname, :lastname, :dob, :gender])
        }
      })
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(:firstname, :lastname, :dob, :gender, employment_attributes: [ :department_id, :hire_date, :termination_date ], payroll_attributes: [ :amount, :cycle ])
    end
end
