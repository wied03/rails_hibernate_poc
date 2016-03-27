require 'jruby/core_ext'

module Bsw
  class Event
    # TODO: Hibernate only finds the attributes if they are set from outside the class (not as ruby @fields)
    def initialize(title, date)
        self.title = title
        self.date = date
    end

    # TODO: Move these out

    java_field 'java.lang.Long id'
    java_field 'java.lang.String title'
    java_field 'java.util.Date date'
  end
end
