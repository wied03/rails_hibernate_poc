import 'org.hibernate.SessionFactory'
import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.cfg.Configuration'
import 'org.hibernate.mapping.Column'
import 'org.hibernate.mapping.RootClass'
import 'org.hibernate.mapping.Property'
import 'org.hibernate.mapping.SimpleValue'

class DummyController < ApplicationController
  def index
    sf = get_session_factory
    session = sf.openSession
    begin
        session.beginTransaction
        result = session.createQuery( "from Event" ).list()
        puts "got result #{result}"
        event = Bsw::Event.new
        puts "event is #{event}"
        event.title = 'howdy'
        event.date = java.util.Date.new
        session.save event
    ensure
        session.close
    end
  end

  def add_col(name, mappings, table)
    col = Column.new
    col.name = name
    table.addColumn col
    mappings.addColumnBinding name, col, table
    col
  end

  def persister_class(model_klass, entity_name, table, mappings)
    event_klass = RootClass.new
    event_klass.entityName = entity_name
    event_klass.jpaEntityName = entity_name
    model_klass = model_klass.become_java!
    raise "model klass name is #{model_klass.getClass().name}"
    event_klass.className = model_klass
    event_klass.proxyInterfaceName = model_klass
    # TODO: Configurable?
    event_klass.lazy = true
    event_klass.table = table
    mappings.addClass event_klass
    mappings.addImport entity_name, entity_name
    event_klass
  end

  def add_property(name, persister_class)
    prop = Property.new
    prop.name = name
    persister_class.addProperty prop
    prop
  end

  def value_map(mappings, type, table, column, property)
    val = SimpleValue.new mappings, table
    val.typeName = type
    val.addColumn column
    property.value = val
  end

  def perform_mappings(mappings)
    table = mappings.addTable '', nil, 'EVENTS', nil, false
    id_col = add_col 'id', mappings, table
    title_col = add_col 'title', mappings, table
    date_col = add_col 'date', mappings, table
    event_klass = persister_class Bsw::Event, 'Event', table, mappings
    id_prop = add_property 'id', event_klass
    title_prop = add_property 'title', event_klass
    date_prop = add_property 'date', event_klass
    value_map mappings, 'org.hibernate.type.LongType', table, id_col, id_prop
    value_map mappings, 'org.hibernate.type.StringType', table, title_col, title_prop
    value_map mappings, 'org.hibernate.type.StringType', table, date_col, date_prop
  end

  def get_session_factory
    @@session_factory ||= begin
        # Don't want to conflict with activesupport
        config = org.hibernate.cfg.Configuration.new
        config.configure '/config/hibernate.cfg.xml'
        mappings = config.createMappings
        perform_mappings mappings
        registry = StandardServiceRegistryBuilder.new.applySettings(config.properties).build
        config.buildSessionFactory(registry)
    end
  end
end
