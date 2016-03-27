module Bsw
  class Event
    attr_reader :id, :desc, :greetings

    def initialize(desc)
        @desc = "#{desc} no way"
        @greetings = Set.new
    end
  end
end
