require_relative "../adapter/pwwka"

module EventLawyer
  module Producer
    class ItemPriceUpdater
      def initialize(adapter: EventLawyer::Adapter::Pwwka.new)
        @adapter = adapter
      end

      def update(item,new_price)

        old_price = item.price
        item.price = new_price
        item.save

        payload = {
          item: {
            id: item.id,
            new_price: item.price,
            old_price: old_price
          }
        }

        @adapter.send_message!(
          payload: payload,
          type: "item_price_change",
        )
      end
    end
  end
end
