module Bsw
  class Event
    attr_reader :id, :desc, :date

    def initialize(desc, date)
        @desc = "#{desc} no way"
        @date = date
    end
  end
end
