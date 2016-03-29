class DummyController < ApplicationController
  def index
    session = SessionFactoryFetcher.session_factory.openSession
    begin
        tran = session.beginTransaction
        result = session.createQuery("from Event").list()
        result.each do |ev|
            puts "result desc #{ev.desc} id #{ev.id}"
            ev.greetings.each do |grt|
                puts "  greeting #{grt.greeting}"
            end
        end
        event = Bsw::Event.new('the event yes')
        Bsw::Foo.new('doody', event)
        session.save event
        tran.commit
    ensure
        session.close
    end

    session = SessionFactoryFetcher.session_factory.openSession
    begin
        tran = session.beginTransaction
        # item = session.get(Bsw::Event.java_class, 1)
        # puts "got item #{item.id}"
        # item.other_way.each do |foo|
        #     puts "foo is #{foo}, #{foo.greeting}, event is #{foo.event}, event id is #{foo.event.id}"
        # end
        event = session.load(Bsw::Event.java_class, 1)
        foo = Bsw::Foo.new('with session load', event)
        session.save foo
        tran.commit
    ensure
        session.close
    end
  end
end
