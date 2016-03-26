import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.boot.MetadataSources'

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
        registry = StandardServiceRegistryBuilder.new.configure('/config/hibernate.cfg.xml').build
        begin
            MetadataSources.new(registry).buildMetadata.buildSessionFactory
        rescue
            StandardServiceRegistryBuilder.destroy registry
        end
    end
  end
end
