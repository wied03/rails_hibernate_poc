import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.boot.registry.BootstrapServiceRegistryBuilder'
import 'org.hibernate.boot.MetadataSources'
require 'overrides/for_all'

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
        result = session.createQuery( "from Event" ).list()
        puts "got result #{result}"
        tran.commit
    ensure
        session.close
    end
  end

  def session_factory
    @@session_factory ||= begin
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
