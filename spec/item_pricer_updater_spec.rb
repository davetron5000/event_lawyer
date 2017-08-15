require "spec_helper"
require "null_ap"

require "event_lawyer/producer/item"
require "event_lawyer/producer/item_price_updater"

describe EventLawyer::Producer::ItemPriceUpdater do
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
      expect(Pwwka::Transmitter).to have_received(:send_message!).with(
        {
          item: {
            id: item.id,
            new_price: new_price,
            old_price: original_price,
          }
        },
        "sf.item_price_change"
      )
    end

  end
end
