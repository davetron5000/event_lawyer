require "awesome_print"
module EventLawyer
  module Consumer
    module PriceCache
    end
  end
end

class EventLawyer::Consumer::PriceCache::Cache
  def initialize
    @cache = {}
  end

  def update_from_message(payload)
    item = payload.fetch("item")
    cache(item.fetch("id"),item.fetch("new_price"))
  end

  def cache(item_id,retail_price)
    ap({
      item_id: item_id,
      retail_price: retail_price,
    })
    @cache[item_id] = retail_price
  end
end
