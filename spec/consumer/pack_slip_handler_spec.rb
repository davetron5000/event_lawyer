require "spec_helper"

require "pack_slip_handler"

describe PackSlipHandler do
  include ExpectationsHelper
  describe "::handle!" do
    let(:pack_slip_repository) { EventLawyer::Consumer::PackSlipGeneration::Repository.new }

    context "when the item exists in a pack slip" do
      let(:item_id) { pack_slip_repository.pack_slips.first.items.first.id }
      let(:price) { "34.12" }

      it "updates the price of that item in the pack slip" do
        receive_message(
          guaranteed_by: :price_change,
          expected_schema: :pack_slip_new_price,
          app_name: "wms",
          use_case: "pack_slip_exists",
          override_sample: {
            "item" => { "id" => item_id, "new_price" => price }
          }
        )
        expect(pack_slip_repository.pack_slips.first.items.first.price).to eq(price)
      end
    end

    context "when the item does not exist in any pack slip" do
      it "no-ops" do
        expect {
          receive_message(
            guaranteed_by: :price_change,
            expected_schema: :pack_slip_new_price,
            app_name: "wms",
            use_case: "pack_slip_does_not_exist",
            override_sample: {
              "item" => { "id" => -100 }
            }
          )
        }.not_to raise_error
      end
    end


  end
end
