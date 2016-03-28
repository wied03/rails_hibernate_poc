class DummyController < ApplicationController
  def index
    session = SessionFactoryFetcher.session_factory.openSession
    begin
        tran = session.beginTransaction
        result = session.createQuery("from Event").list()
        puts "got result #{result}"
        result.each do |ev|
            puts "result desc #{ev.desc}"
            ev.greetings.each do |grt|
                puts "greeting #{grt.greeting}"
            end
        end
        event = Bsw::Event.new('the event yes')
        event.greetings << Bsw::Foo.new('doody')
        session.flush
        session.save event
        tran.commit
    ensure
        session.close
    end
  end
end
