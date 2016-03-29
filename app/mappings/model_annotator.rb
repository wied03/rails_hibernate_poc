require 'jruby/core_ext'

module ModelAnnotator
    def self.annotate(klass, fields)
        klass.class_eval do
            fields.each do |field, type|
                java_field = field.to_s.clone
                java_field[0] = java_field[0].upcase

                ivar = "@#{field}".to_sym

                getter = "get#{java_field}".to_sym

                java_signature "private #{type} #{getter}()"
                define_method(getter) { instance_variable_get(ivar) }
                private getter

                setter = "set#{field}".to_sym

                java_signature "private void #{setter}(#{type})"
                define_method(setter) { |value|
                    instance_variable_set(ivar, value)
                    if self.is_a? Bsw::Event
                        puts "setter called for ivar #{ivar}, method result is #{self.greetings}"
                    end
                }
                private setter
            end
        end
        klass.become_java!
    end
end
