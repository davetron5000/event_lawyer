require_relative "pack_slip"
class EventLawyer::Consumer::PackSlipGeneration::Repository

  attr_reader :pack_slips

  def initialize
    @pack_slips = [
      EventLawyer::Consumer::PackSlipGeneration::PackSlip.new(1234),
      EventLawyer::Consumer::PackSlipGeneration::PackSlip.new(4567),
    ]
  end
  def find_by_item(item_id)
    @pack_slips.detect { |pack_slip|
      pack_slip.items.map(&:id).include?(item_id)
    }
  end
end
