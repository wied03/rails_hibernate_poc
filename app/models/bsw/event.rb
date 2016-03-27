module Bsw
  class Event
    attr_reader :id, :title, :date

    def initialize(title, date)
        @title = title
        @date = date
    end
  end
end
