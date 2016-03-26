import 'org.hibernate.SessionFactory'
import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.boot.MetadataSources'

class DummyController < ApplicationController
  def index
    sf = get_session_factory
    session = sf.openSession
    begin
        session.beginTransaction
        result = session.createQuery( "from Event" ).list()
        puts "got result #{result}"
    ensure
        session.close
    end
  end

  def get_session_factory
    @@session_factory ||= begin
        registry = StandardServiceRegistryBuilder.new.configure('/config/hibernate.cfg.xml').build
        begin
            sf = MetadataSources.new(registry).buildMetadata.buildSessionFactory
            puts "built session factory #{sf}"
            sf
        ensure
            StandardServiceRegistryBuilder.destroy registry
        end
    end
  end
end
