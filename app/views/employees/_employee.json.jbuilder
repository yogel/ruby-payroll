json.extract! employee, :id, :firstname, :lastname, :dob, :gender, :created_at, :updated_at
json.url employee_url(employee, format: :json)
