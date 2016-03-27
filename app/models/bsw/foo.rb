module Bsw
  class Foo
    attr_reader :id, :greeting

    def initialize(greeting)
        @greeting = "greetings #{greeting}"
    end
  end
end
