# TODO: THis can probably be migrated closer to the Hibernate code
require 'jruby/core_ext'

module Bsw
  class Event
    attr_reader :id, :title, :date

    def initialize(title, date)
        @title = title
        @date = date
    end
  end
end
