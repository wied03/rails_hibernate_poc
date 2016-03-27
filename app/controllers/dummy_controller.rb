class DummyController < ApplicationController
  def index
    session = SessionFactoryFetcher.session_factory.openSession
    begin
        tran = session.beginTransaction
        result = session.createQuery("from Event").list()
        puts "got result #{result}"
        result.each do |ev|
            puts "event is #{ev.desc}"
        end
        event = Bsw::Event.new('the event yes', java.util.Date.new(Time.now.to_i*1000))
        session.save event
        tran.commit
    ensure
        session.close
    end
  end
end
