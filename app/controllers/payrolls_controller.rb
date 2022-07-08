require "#{Rails.root}/lib/services/my_service"

class PayrollsController < ApplicationController
  before_action :set_payroll, only: %i[ show edit update destroy ]

  def initialize
    super

    @payroll_event_stream = Services::EventStream.new('payroll-first-live-test')
  end

  # GET /payrolls or /payrolls.json
  def index
    @payrolls = Payroll.all
  end

  # GET /payrolls/1 or /payrolls/1.json
  def show
  end

  # GET /payrolls/new
  def new
    @payroll = Payroll.new
    @employees = Employee.all
  end

  # GET /payrolls/1/edit
  def edit
    @employees = Employee.all
  end

  # POST /payrolls or /payrolls.json
  def create
    @payroll = Payroll.new(payroll_params)

    respond_to do |format|
      if @payroll.save
        format.html { redirect_to payroll_url(@payroll), notice: "Payroll was successfully created." }
        format.json { render :show, status: :created, location: @payroll }

        @payroll_event_stream.emitEvent({
          type: 'payroll-created',
          payload: {
            id: @payroll.id,
            employee_id: @payroll.employee_id,
            amount: @payroll.amount,
            cycle: @payroll.cycle
          }
        })
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payrolls/1 or /payrolls/1.json
  def update
    respond_to do |format|
      if @payroll.update(payroll_params)
        format.html { redirect_to payroll_url(@payroll), notice: "Payroll was successfully updated." }
        format.json { render :show, status: :ok, location: @payroll }

        @payroll_event_stream.emitEvent({
          type: 'payroll-updated',
          payload: {
            id: @payroll.id,
            employee_id: @payroll.employee_id,
            amount: @payroll.amount,
            cycle: @payroll.cycle
          }
        })
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payrolls/1 or /payrolls/1.json
  def destroy
    @payroll.destroy

    respond_to do |format|
      format.html { redirect_to payrolls_url, notice: "Payroll was successfully destroyed." }
      format.json { head :no_content }

      @payroll_event_stream.emitEvent({
        type: 'payroll-deleted',
        payload: {
          id: @payroll.id,
          employee_id: @payroll.employee_id,
          amount: @payroll.amount,
          cycle: @payroll.cycle
        }
      })
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payroll_params
      params.require(:payroll).permit(:amount, :cycle)
    end
end
