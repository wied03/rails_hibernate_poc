import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.boot.registry.BootstrapServiceRegistryBuilder'
import 'org.hibernate.boot.MetadataSources'
require 'overrides/for_all'
require 'jruby/core_ext'

class RubyHibernateModelCl < java.lang.ClassLoader
    def initialize(*model_classes)
        @class_mapping = Hash[model_classes.map do |klass|
            [RubyHibernateModelCl.get_java_class_name(klass), klass.become_java!]
        end]
        super()
    end

    def self.get_java_class_name(klass)
        klass_parts = klass.name.split('::')
        klass_parts.unshift 'rubyobj'
        klass_parts.join '.'
    end

    # TODO: Would need to unload this somehow for hot model reloads

    overrides
    def findClass(class_name)
        if @class_mapping.include? class_name
            @class_mapping[class_name]
        else
            raise java.lang.ClassNotFoundException.new("#{class_name} is not a model class, so expecting other loader to find it")
        end
    end
end

class DummyController < ApplicationController
  def index
    session = session_factory.openSession
    begin
        tran = session.beginTransaction
        result = session.createQuery("from Event").list()
        puts "got result #{result}"
        result.each do |ev|
            puts "event is #{ev.title}"
        end
        event = Bsw::Event.new('the event yes', java.util.Date.new(Time.now.to_i*1000))
        session.save event
        tran.commit
    ensure
        session.close
    end
  end

  def session_factory
    @@session_factory ||= begin
        # TODO: Would probably need some Fluent mapping code anyways that runs on startup
        # it could generate the XML and then, based on mapped attributes,
        # monkey patch all of these classes
        Bsw::Event.class_eval do
            private

            # private in ruby does not mean private w/ Java signature
            java_signature 'private java.lang.Long getId()'
            def getId
                @id
            end

            java_signature 'private void setId(java.lang.Long)'
            def setId(id)
                @id = id
            end

            java_signature 'private java.lang.String getTitle()'
            def getTitle
                @title
            end

            java_signature 'private void setTitle(java.lang.String)'
            def setTitle(title)
                @title = title
            end

            java_signature 'private java.util.Date getDate()'
            def getDate
                @date
            end

            java_signature 'private void setDate(java.util.Date)'
            def setDate(date)
                @date = date
            end
        end
        our_loader = RubyHibernateModelCl.new(Bsw::Event)
        bootstrap = BootstrapServiceRegistryBuilder.new
        .applyClassLoader(our_loader)
        .build

        registry = StandardServiceRegistryBuilder.new(bootstrap)
        .configure('/config/hibernate.cfg.xml')
        .build
        begin
            MetadataSources.new(registry).buildMetadata.buildSessionFactory
        rescue
            StandardServiceRegistryBuilder.destroy registry
            raise
        end
    end
  end
end
