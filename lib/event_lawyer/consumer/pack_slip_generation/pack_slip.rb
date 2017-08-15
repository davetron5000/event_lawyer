require_relative "pack_slip"

class EventLawyer::Consumer::PackSlipGeneration::PackSlip
  attr_reader :items
  def initialize(item_id_it_contains)
    @items = [
      EventLawyer::Consumer::PackSlipGeneration::Item.new(id: item_id_it_contains, price: 12),
      EventLawyer::Consumer::PackSlipGeneration::Item.new(id: item_id_it_contains + 1, price: 12),
      EventLawyer::Consumer::PackSlipGeneration::Item.new(id: item_id_it_contains - 1, price: 12),
    ]
  end
end
