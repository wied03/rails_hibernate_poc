module Bsw
  class Foo
    attr_reader :id, :greeting, :event

    def initialize(greeting, event)
        @event = event
        @event.greetings << self
        @greeting = "greetings #{greeting}"
    end
  end
end
