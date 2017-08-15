require_relative "pack_slip"
class EventLawyer::Consumer::PackSlipGeneration::Repository

  @@pack_slips = []

  def initialize
    if @@pack_slips.empty?
      @@pack_slips << EventLawyer::Consumer::PackSlipGeneration::PackSlip.new(1234)
      @@pack_slips << EventLawyer::Consumer::PackSlipGeneration::PackSlip.new(4567)
    end
  end

  def pack_slips
    @@pack_slips
  end

  def find_by_item(item_id)
    @@pack_slips.detect { |pack_slip|
      pack_slip.items.map(&:id).include?(item_id)
    }
  end
end
