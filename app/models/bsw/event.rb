require 'jruby/core_ext'

module Bsw
  class Event
    attr_reader :id, :title, :date

    def initialize(title, date)
        @title = title
        @date = date
    end

    # TODO: Move these out

    java_field 'java.lang.Long id'
    java_field 'java.lang.String title'
    java_field 'java.util.Date date'
  end
end
