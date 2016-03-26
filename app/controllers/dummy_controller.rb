import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.boot.registry.BootstrapServiceRegistryBuilder'
import 'org.hibernate.boot.MetadataSources'
require 'overrides/for_all'

class RubyHibernateModelCl < java.lang.ClassLoader
    def initialize(*model_classes)
        @class_mapping = Hash[model_classes.map{|klass| [klass.name.gsub('::', '.'), klass.become_java!]}]
        puts "setup class mapping as #{@class_mapping}"
        super()
    end

    overrides
    def findClass(class_name)
        puts "findClass request for #{class_name}"
        if @class_mapping.include? class_name
            puts 'subbing in model from ruby side'
            begin
                klass = @class_mapping[class_name]
                puts "klass is #{klass}"
                puts "klass fields are #{klass.declared_fields.map(&:name)}"
                klass
            rescue Exception => e
                puts "Unable, #{e}"
                super
            end
        else
            puts 'passing through'
            super
        end
    end

    overrides
    def loadClass(class_name)
        puts "got load request for #{class_name}"
        super
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
        bootstrap = BootstrapServiceRegistryBuilder.new
        .applyClassLoader(RubyHibernateModelCl.new(Bsw::Event))
        .build
        puts "bootstrap builder is #{bootstrap}"
        registry = StandardServiceRegistryBuilder.new(bootstrap)
        .configure('/config/hibernate.cfg.xml')
        .build
        begin
            MetadataSources.new(registry).buildMetadata.buildSessionFactory
        rescue
            StandardServiceRegistryBuilder.destroy registry
        end
    end
  end
end
