require "spec_helper"
require "json-schema"

require "event_lawyer/producer/item"
require "event_lawyer/producer/item_price_updater"

describe EventLawyer::Producer::ItemPriceUpdater do
  include SchemaHelper
  include CentralAuthority
  subject { described_class.new(printer: NullAp.new) }
  describe "#update" do
    let(:original_price) { "12.34" }
    let(:new_price)      { "34.45" }
    let(:item)           { EventLawyer::Producer::Item.new(1,original_price) }

    before do
      allow(Pwwka::Transmitter).to receive(:send_message!)
      subject.update(item,new_price)
    end

    it "should update the item's price" do
      expect(item.price).to eq(new_price)
    end

    it "should send a message about it" do
      expect(Pwwka::Transmitter).to have_sent_message(
        matching_schema: :item_price_change,
        identified_by: :price_change,
        payload_including: {
          item: {
            id: item.id,
            new_price: new_price,
            old_price: original_price,
          }
        },
        on_routing_key: "sf.item_price_change"
      )
    end

  end
end

RSpec::Matchers.define :have_sent_message do |options|
  match do |mock|
    received_payload = nil
    received_routing_key = nil
    expect(mock).to have_received(:send_message!) do |payload,routing_key|
      received_payload     = payload
      received_routing_key = routing_key
    end
    expect(received_routing_key).to eq(options.fetch(:on_routing_key))
    expect(options.fetch(:payload_including).to_a - received_payload.to_a).to eq([])

    schema = schema_named(options.fetch(:matching_schema))
    JSON::Validator.validate!(schema, received_payload.to_json)

    File.open(guarantee(options.fetch(:identified_by)),"w") do |file|
      file.puts({
        id: options.fetch(:identified_by),
        schema: JSON.parse(schema),
        metadata: {
          routing_key: received_routing_key,
        },
        example_payload: received_payload,
      }.to_json)
    end
    true
  end
end
