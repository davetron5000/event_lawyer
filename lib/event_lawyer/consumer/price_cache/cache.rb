require "awesome_print"
module EventLawyer
  module Consumer
    module PriceCache
    end
  end
end

class EventLawyer::Consumer::PriceCache::Cache
  attr_reader :cache
  def initialize(printer: Kernel)
    @cache = {}
    @printer = printer
  end

  def [](item_id)
    @cache[item_id]
  end

  def update_from_message(payload)
    item = payload.fetch("item")
    cache_price(item.fetch("id"),item.fetch("new_price"))
  end

  def cache_price(item_id,retail_price)
    if ENV["DEBUG"]
      @printer.ap({
        item_id: item_id,
        retail_price: retail_price,
      })
    end
    @cache[item_id] = retail_price
  end
end
