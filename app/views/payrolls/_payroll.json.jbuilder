json.extract! payroll, :id, :amount, :cycle, :created_at, :updated_at
json.url payroll_url(payroll, format: :json)
