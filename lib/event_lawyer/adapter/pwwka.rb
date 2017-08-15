require "pwwka"
require "awesome_print"

module EventLawyer
  module Adapter
    class Pwwka
      def send_message!(payload:, type:)
        routing_key = "sf.#{type}"
        ap({
          routing_key: routing_key,
          payload: payload,
        })
        ::Pwwka::Transmitter.send_message!(payload,routing_key)
      end
    end
  end
end
