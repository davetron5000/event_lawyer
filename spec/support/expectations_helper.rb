require "json-schema"
require_relative "schema_helper"
require_relative "central_authority"

module ExpectationsHelper
  include SchemaHelper
  include CentralAuthority

  def receive_message(guaranteed_by: ,
                      app_name: ,
                      use_case: ,
                      expected_schema: ,
                      override_sample: {})
    schema = schema_named(expected_schema)
    remote_guarantee = JSON.parse(File.read(guarantee(guaranteed_by)))

    payload = remote_guarantee["example_payload"]
    if override_sample["item"]
      payload["item"].merge!(override_sample["item"])
    end
    routing_key = remote_guarantee["metadata"]["routing_key"]
    delivery_info = double("delivery_info", routing_key: routing_key)

    JSON::Validator.validate!(schema, payload.to_json)
    puts "✅ Message we received matches our schema"

    described_class.handle!(
      delivery_info,
      double("properties"),
      payload)

    File.open(expectation(app_name,use_case,guaranteed_by),"w") do |file|
      file.puts({
        app_name: app_name,
        use_case: use_case,
        guarantee_id: guaranteed_by,
        schema: JSON.parse(schema),
        example_payload: payload,
      }.to_json)

      payload
    end
  end
end
