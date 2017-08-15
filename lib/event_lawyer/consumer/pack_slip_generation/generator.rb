require "awesome_print"
module EventLawyer
  module Consumer
    module PackSlipGeneration
    end
  end
end

class EventLawyer::Consumer::PackSlipGeneration::Generator
  def initialize
  end

  def regenerate_from_message(payload)
    item = payload.fetch("item")
    item_id = item.fetch("id")
    new_price = item.fetch("new_price")

    regenerate_slip_with_item(item_id,{ price: new_price })
  end

  def regenerate_slip_with_item(item_id, updated_attributes)
    # hand-wavy
    ap({
      item_id: item_id,
      attributes: updated_attributes
    })
  end
end
