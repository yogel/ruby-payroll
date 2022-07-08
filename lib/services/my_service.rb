require 'event_store_client'

module Services
  class CreateEvent < EventStoreClient::DeserializedEvent
    def schema
      Dry::Schema.Params do
        required(:type).value(:string)
        required(:payload).value(:hash)
      end
    end
  end

  class EventStream
    attr_accessor :stream

    def initialize(stream)
      EventStoreClient.configure do |config|
        config.eventstore_url = "http://localhost:2113"
        config.adapter = :http
        config.eventstore_user = "admin"
        config.eventstore_password = "changeit"
        config.verify_ssl = false
      end

      @stream = stream
      @event_store = EventStoreClient::Client.new
    end

    def emitEvent(data)
      event = Services::CreateEvent.new(
        data: data,
      )

      @event_store.publish(stream: @stream, events: [ event ])
    end
  end
end






