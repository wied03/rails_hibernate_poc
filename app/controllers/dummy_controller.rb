import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.boot.registry.BootstrapServiceRegistryBuilder'
import 'org.hibernate.boot.MetadataSources'
require 'overrides/for_all'

class RubyHibernateModelCl < java.lang.ClassLoader
    def initialize(*model_classes)
        @class_mapping = Hash[model_classes.map{|klass| [RubyHibernateModelCl.get_java_class_name(klass), klass.become_java!]}]
        puts "setup class mapping as #{@class_mapping}"
        super()
    end

    def self.get_java_class_name(klass)
        # TODO: The case is probably not the reason for the error
        klass_parts = klass.name.split('::')
        class_only = klass_parts.last
        klass_parts.map do |part|
            part == class_only ? part : part.downcase
        end.join '.'
    end

    # TODO: Would need to unload this somehow for hot model reloads

    overrides
    def getPackage(pkg_name)
        puts "got get package request #{pkg_name}"
        super
    end

    overrides
    def resolveClass(klass)
        puts "got resolve class #{klass}"
        super
    end

    overrides
    def findClass(class_name)
        puts "findClasss request for #{class_name}"
        if @class_mapping.include? class_name
            puts 'subbing in model from ruby side'
            begin
                klass = @class_mapping[class_name]
                puts "klass is #{klass}"
                puts "klass fields are #{klass.declared_fields.map(&:name)}"
                return klass
            rescue Exception => e
                puts "Unable, #{e}"
                super
            end
        else
            puts 'raising exception to get hibernate to try its other classloaders'
            raise java.lang.ClassNotFoundException.new("#{class_name} is not a model class, so expecting other loader to find it")
        end
    end

    overrides
    def loadClass(class_name, resolve)
        begin
            puts "loadClass #{class_name}, resolve is #{resolve}"
            #java.lang.Thread.dumpStack
            result = super
            puts "load super complete, returned #{result}"
            return result
        rescue
            puts 'got exception in load'
            raise
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
        puts "bootstrap builder is #{bootstrap}"

        #class_svc = bootstrap.getService(org.hibernate.boot.registry.classloading.spi.ClassLoaderService)
        # TODO: once we get our own loader working with forName, then look at the aggregate loader
        #puts "class svc is #{class_svc}, fetching model"
        #method = class_svc.getClass.getDeclaredMethod('getAggregatedClassLoader')
        #method.accessible = true
        #agg_loader = method.invoke(class_svc)
        #puts "agg loader #{agg_loader}"
        # TODO: ensure this works with initialize = true (2nd param)
        # TODO: Why is this not working? even though our class loader returns a class, it's not working
        # maybe find and check JVM_FindClassFromClassLoader in the openjdk source
        java.lang.Class.forName('bsw.Event', false, our_loader)
        raise 'passed!'
        #puts class_svc.classForName("Bsw.Event")

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
