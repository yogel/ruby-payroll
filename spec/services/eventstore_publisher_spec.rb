require 'event_store_client'
require "event_store_client/adapters/grpc"
require "#{Rails.root}/lib/services/my_service"

RSpec.describe 'Hello world' do
  it "Connects to the store and emits an event" do
    payroll_event_stream_test = Services::EventStream.new('happy-test')
    payroll_event_stream_test.emitEvent({
      type: 'yup',
      payload: {
        id: 1,
        name: 'John'
      }
    })
  end
end