require "awesome_print"
module EventLawyer
  module Consumer
    module PackSlipGeneration
    end
  end
end
require_relative "repository"
require_relative "item"
require_relative "pack_slip"

class EventLawyer::Consumer::PackSlipGeneration::Generator
  def initialize(pack_slip_repository: EventLawyer::Consumer::PackSlipGeneration::Repository.new, printer: Kernel)
    @pack_slip_repository = pack_slip_repository
    @printer = printer
  end

  def regenerate_from_message(payload)
    item = payload.fetch("item")
    item_id = item.fetch("id")
    new_price = item.fetch("new_price")

    regenerate_slip_with_item(item_id,{ price: new_price })
  end

  def regenerate_slip_with_item(item_id, updated_attributes)
    if ENV["DEBUG"]
      @printer.ap({
        item_id: item_id,
        attributes: updated_attributes
      })
    end
    pack_slip = @pack_slip_repository.find_by_item(item_id)
    unless pack_slip.nil?
      item = pack_slip.items.detect { |item| item.id == item_id }
      unless item.nil?
        item.update(updated_attributes)
      end
    end
  end
end
