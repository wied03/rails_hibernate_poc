module Bsw
  class Event
    attr_reader :id, :desc, :greetings

    def initialize(desc)
        @desc = "#{desc} no way"
        @greetings = []
    end

    def other_way
        @greetings
    end
  end
end
