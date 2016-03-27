require 'overrides/for_all'
require 'jruby/core_ext'

class ModelClassLoader < java.lang.ClassLoader
    def initialize(*model_classes)
        @class_mapping = Hash[model_classes.map do |klass|
            [ModelClassLoader.get_java_class_name(klass), klass.become_java!]
        end]
        super()
    end

    def self.get_java_class_name(klass)
        klass_parts = klass.name.split('::')
        klass_parts.unshift 'rubyobj'
        klass_parts.join '.'
    end

    overrides
    def findClass(class_name)
        if @class_mapping.include? class_name
            @class_mapping[class_name]
        else
            raise java.lang.ClassNotFoundException.new("#{class_name} is not a model class, so expecting other loader to find it")
        end
    end
end
