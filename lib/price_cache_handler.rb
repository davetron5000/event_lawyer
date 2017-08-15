require "event_lawyer/consumer/price_cache/cache"

class PriceCacheHandler
  def self.handle!(delivery_info, properties, payload)
    cache.update_from_message(payload)
  end

  def self.cache
    @cache ||= EventLawyer::Consumer::PriceCache::Cache.new
  end
end
