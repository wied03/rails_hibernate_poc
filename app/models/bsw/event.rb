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

    become_java!
  end
#end
