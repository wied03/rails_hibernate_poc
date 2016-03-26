import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.boot.registry.BootstrapServiceRegistryBuilder'
import 'org.hibernate.boot.MetadataSources'
require 'overrides/for_all'

class RubyHibernateModelCl < java.lang.ClassLoader
    overrides
    def findClass(class_name)
        puts "got request for #{class_name}"
        super
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
        .applyClassLoader(RubyHibernateModelCl.new)
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
