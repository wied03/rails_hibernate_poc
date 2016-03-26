require 'jruby/core_ext'

#module Bsw

  java_package 'bsw'

  class Event
    attr_accessor :id
    attr_accessor :title
    attr_accessor :date
    java_field 'java.lang.Long id'
    java_field 'java.lang.String title'
    java_field 'java.util.Date date'

    def getId
      @id
    end

    def setId(id)
      @id = id
    end

    def getTitle
      @title
    end

    def setTitle(title)
      @title = title
    end

    def getDate
      @date
    end

    def setDate(date)
      @date = date
    end

    become_java!
  end
#end
