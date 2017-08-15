require "spec_helper"
require "json-schema"

require "pack_slip_handler"

describe PackSlipHandler do
  describe "::handle!" do
    let(:pack_slip_repository) { EventLawyer::Consumer::PackSlipGeneration::Repository.new }

    context "when the item exists in a pack slip" do
      let(:item_id) { pack_slip_repository.pack_slips.first.items.first.id }
      let(:price) { "34.12" }

      it "updates the price of that item in the pack slip" do
        described_class.handle!(
          double("delivery info"),
          double("properties"),
          payload_matching_schema(
            :pack_slip_new_price,
            with_specific_values: {
              item: { id: item_id, new_price: price }
            }
          )
        )
        expect(pack_slip_repository.pack_slips.first.items.first.price).to eq(price)
      end
    end

    context "when the item does not exist in any pack slip" do
      it "no-ops" do
        expect {
          described_class.handle!(
            double("delivery info"),
            double("properties"),
            payload_matching_schema(
              :pack_slip_new_price,
              with_specific_values: {
                item: { id: -100}
              }
            )
          )
        }.not_to raise_error
      end
    end

    def payload_matching_schema(schema_name,with_specific_values: {})
      schema = File.read(Pathname(__FILE__).dirname / ".." / "schemas" / "#{schema_name}.schema.json")
      payload = {
        item: {
          id: rand(10000),
          new_price: (rand(100000) / 100.0).to_s,
        }.merge(with_specific_values[:item] || {})
      }.to_json
      JSON::Validator.validate!(schema, payload)
      JSON.parse(payload)
    end

  end
end
