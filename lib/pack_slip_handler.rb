require "awesome_print"
require "event_lawyer/consumer/pack_slip_generation/generator"

class PackSlipHandler
  def self.handle!(delivery_info, properties, payload)
    generator = EventLawyer::Consumer::PackSlipGeneration::Generator.new
    generator.regenerate_from_message(payload)
  end
end
