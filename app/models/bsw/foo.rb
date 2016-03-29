module Bsw
  class Foo
    attr_reader :id, :greeting, :event

    def initialize(greeting, event)
        @event = event
        @greeting = "greetings #{greeting}"
    end
  end
end
