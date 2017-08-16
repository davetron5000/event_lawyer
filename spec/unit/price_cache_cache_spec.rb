require "spec_helper"
require "event_lawyer/consumer/price_cache/cache"

describe EventLawyer::Consumer::PriceCache::Cache do
  include ExpectationsHelper
  describe "#update_from_message" do
    let(:item_id) { 12 }
    let(:price) { "34.12" }

    let(:payload) {
      {
        "item" => {
          "id" => item_id,
          "new_price" => price,
        }
      }
    }
    subject { described_class.new(printer: NullAp.new) }

    it "updates the cache with the new price" do
      subject.update_from_message(payload)
      expect(subject.cache[item_id]).to eq(price)
    end
  end
end
