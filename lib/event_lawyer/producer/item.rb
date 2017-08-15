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
        puts "Saved utem #{id}"
      end
    end
  end
end
