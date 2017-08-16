require "spec_helper"

require "event_lawyer/consumer/pack_slip_generation/generator"

describe EventLawyer::Consumer::PackSlipGeneration::Generator do
  describe "#update_from_message" do
    let(:pack_slip_repository) { EventLawyer::Consumer::PackSlipGeneration::Repository.new }

    let(:payload) {
      {
        "item" => {
          "id" => item_id,
          "new_price" => price,
        }
      }
    }

    subject { described_class.new(printer: NullAp.new) }

    context "when the item exists in a pack slip" do
      let(:item_id) { pack_slip_repository.pack_slips.first.items.first.id }
      let(:price) { "34.12" }

      it "updates the price of that item in the pack slip" do
        subject.regenerate_from_message(payload)
        expect(pack_slip_repository.pack_slips.first.items.first.price).to eq(price)
      end
    end

    context "when the item does not exist in any pack slip" do
      let(:item_id) { -100 }
      let(:price) { "34.12" }

      it "no-ops" do
        expect {
          subject.regenerate_from_message(payload)
        }.not_to raise_error
      end
    end

  end
end
