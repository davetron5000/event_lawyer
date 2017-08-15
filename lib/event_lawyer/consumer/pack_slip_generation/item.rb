class EventLawyer::Consumer::PackSlipGeneration::Item
  attr_reader :id, :price
  def initialize(id:, price: )
    @id = id
    @price = price
  end

  def update(attributes)
    if attributes["price"] || attributes[:price]
      @price = attributes["price"] || attributes[:price]
    end
  end
end
