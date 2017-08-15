require "pwwka"
require "awesome_print"

module EventLawyer
  module Producer
    class ItemPriceUpdater
      def initialize(printer: Kernel)
        @printer = printer
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

        routing_key = "sf.item_price_change"
        @printer.ap({
          routing_key: routing_key,
          payload: payload,
        })
        ::Pwwka::Transmitter.send_message!(payload,routing_key)
      end
    end
  end
end
