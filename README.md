# event-lawyer - enforcing guarantees and expectations for messaging

A _Producer_ sends messages that others consume.  A _Consumer_ consumes that message.  To ensure that changes in either don't
break the overall system, we can enforce a contract.  The Producer provides a _guarantee_ of what it produces.  The Consumer
publishes an _expectation_ of what it needs.

The guarantees and expectations can be published in a centralized store such that both sides can check that they aren't breaking
anything.

## WTF is in this repo

This has example code of one producer, `ItemPriceUpdater` that sends messages on a Rabbit exchange about the change in price of
an item.  There are two consumers, `PriceCacheHandler`, which updates a cache of item prices for financial purposes, and
`PackSlipHandler`, which updates packing slips with the updated item prices.

* `schemas/` - schemas for the producers and consumers
  * `item_price_change.schema.json` - The schema of what the producer is sending
  * `pack_slip_new_price.schema.json` - The schema of what the `PackSlipHandler` is expecting
  * `price_cache_price_change.schema.json` - The schema of what the `PriceCacheHandler` is expecting
* `central_authority/` - mimics a central server where the guarantees and expectations are stored
  * `expectations` - mimics the expectations consumers have on producers
    * `financial_data_warehouse.cache_price.price_change.expectation.json` - An app called "financial data warehouse" has an
    expectation on the "price change" guarantee related to a use case called "cache price"
    * `wms.pack_slip_does_not_exist.price_change.expectation.json` - An app called "wms" has an expectation
    on the "price change" guarantee related to a use case called "pack slip does not exist"
    * `wms.pack_slip_exists.price_change.expectation.json` - An app called "wms" has an expectation on the
    "price change" guarantee related to a use case called "pack slip exists"
  * `guarantees`
    * `price_change.guarantee.json` - a guaratee called "price change" that a message will be sent and others can rely on

## How it works

When you run the test of the producer, it requires a schema for its payload, and writes out the guarantee.  When you run the test
of a consumer, it grabs that guarantee and feeds an example payload into itself to start the test.  It evaluates the payload
against *it's* schema and then writes out an expectation capturing all this. The producer, when the tests are re-run, will grab
these expectations and evaluate the sample payloads against *it's* schema.

# Terms

## Guarantee

A guarantee consists of three parts:

* Unique identifier - this should be human readable and unique across your infrastructure.
* A JSON Schema - the schema of what the payload will conform to
* Metadata Guarantees - Guarantees about any metadata.  This is messaging-system-specific

## Expectation

An expectation consists of three parts:

* Guarantee's Unique identifier - the unique identifier of the guarantee the consumer expects
* A JSON Schema - the schema of what the payload must confirm to for the expectation to be met
* Metadata Expectations - Expectations about any metadata.  This is messaging-system-specific

## System Components

The system requires three components to work:

* A testing framework that produces guarantees based on messages sent by the Producer.
* A testing framework that produces expectations of the Consumer, given a guarantee.
* A central store of guarantees and expectations.

### Producer Testing Framework

Absent this system, the producer would have a test that asserts it sends a message.  The testing framework here would augment
that test to produce a guarantee.  It must:

* Take a schema as input
* Take an id as input
* Take metadata guarantees as input
* Assert that the message sent during the test matches the guarantee

It must further, if given an Expectation:

* Assert that the guarantee meets the expectation.

```ruby
it "sends a message" do
  allow(Pwwka::Transmitter).to receive(:send_message!)

  MyApp.do_stuff!

  expect(Pwwka::Transmitter).to have_received(:send_message!).with(payload)

  guarantee = Guarantee.new(schema: "my_schema.json", id: "My Stuff", metadata: { routing_key: "sf.foo.bar" })
  expect(Pwwka::Transmitter).to have_received(:send_message!).with(provides_guarantee(guarantee))
end
```

### Consumer Testing Framework

Absent this system, the consumer would have a test that when it receives a message, that message triggers some expected code.
The testing framework here would:

* Take the id of a guarantee as input
* Take a JSON schema as input
* Take metadata expectations as input
* Craft an input message

Further, it must:

* Fetch the named guarantee
* Evaluate the schema against it
* Evaluate the test agains a payload matching the expectation schema

```ruby
it "processes a message" do

end
```
