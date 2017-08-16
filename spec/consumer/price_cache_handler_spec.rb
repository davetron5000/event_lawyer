require "spec_helper"
require "price_cache_handler"

describe PriceCacheHandler do
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

    it "updates the cache with the new price" do
      payload = receive_message(
        guaranteed_by: :price_change,
        expected_schema: :price_cache_price_change,
        app_name: "financial_data_warehouse",
        use_case: "cache_price")
      expect(PriceCacheHandler.cache[payload["item"]["id"]]).to eq(payload["item"]["new_price"])
    end
  end
end
