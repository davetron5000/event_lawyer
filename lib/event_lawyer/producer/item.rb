module EventLawyer
  module Producer
    class Item
      attr_reader :id
      attr_accessor :price
      def initialize(id, price)
        @id = id
        @price = price
      end

      def save
      end
    end
  end
end
