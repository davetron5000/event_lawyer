# event-lawyer - enforcing guarantees and expectations for messaging

A _Producer_ sends messages that others consume.  A _Consumer_ consumes that message.  To ensure that changes in either don't
break the overall system, we can enforce a contract.  The Producer provides a _guarantee_ of what it produces.  The Consumer
publishes an _expectation_ of what it needs.

The guarantees and expectations can be published in a centralized store such that both sides can check that they aren't breaking
anything.

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
