import 'org.hibernate.SessionFactory'
import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.cfg.Configuration'

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
        # Don't want to conflict with activesupport
        config = org.hibernate.cfg.Configuration.new
        config.configure '/config/hibernate.cfg.xml'
        registry = StandardServiceRegistryBuilder.new.applySettings(config.properties).build
        config.buildSessionFactory(registry)
    end
  end
end
