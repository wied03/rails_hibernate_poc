import 'org.hibernate.SessionFactory'
import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.cfg.Configuration'

class DummyController < ApplicationController
  def index
    sf = get_session_factory
  end
  
  def get_session_factory
    @@session_factory ||= begin
      Configuration.new.configure('config/hibernate.cfg.xml').buildSessionFactory(StandardServiceRegistryBuilder.new().build())
    end
  end
end
