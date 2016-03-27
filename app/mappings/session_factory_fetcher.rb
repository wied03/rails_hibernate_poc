import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.boot.registry.BootstrapServiceRegistryBuilder'
import 'org.hibernate.boot.MetadataSources'

class LoggingInterceptor < org.hibernate.EmptyInterceptor
    overrides
    def onSave(entity, id, state, property_names, types)
        puts "got call for entity #{entity} prop names #{property_names.to_a}"

        constructor = java.util.HashSet.java_class.constructor(java.util.Collection)
        item = constructor.new_instance(state[1].to_a.to_java)
        puts "replacing with #{item}"
        state[1] = item
        true

        # modified = false

        # state.to_a.each_index do |index|
        #     if state[index].is_a? Set
        #         n = state[index].to_java('java.util.Set')
        #         puts "modifying #{state[index]} to #{n}"
        #         state[index] = n
        #         modified = true
        #     end
        # end

        # modified
    end
end

class SessionFactoryFetcher
    def self.session_factory
        @session_factory ||= begin
            # TODO: Map ruby types to java ones with some fluent mapping code??
            fields = {
                id: 'java.lang.Long',
                desc: 'java.lang.String',
                greetings: 'java.util.Set'
            }
            # TODO: Find models automatically
            ModelAnnotator.annotate(Bsw::Event, fields)
            fields = {
                id: 'java.lang.Long',
                greeting: 'java.lang.String',
                event: 'java.lang.Object'
            }
            ModelAnnotator.annotate(Bsw::Foo, fields)

            our_loader = ModelClassLoader.new(Bsw::Event, Bsw::Foo)
            bootstrap = BootstrapServiceRegistryBuilder.new
            .applyClassLoader(our_loader)
            .build

            registry = StandardServiceRegistryBuilder.new(bootstrap)
            .configure('/config/hibernate.cfg.xml')
            .build
            begin
                metadata = MetadataSources.new(registry).buildMetadata
                metadata.session_factory_builder
                .apply_interceptor(LoggingInterceptor.new)
                .build
            rescue
                StandardServiceRegistryBuilder.destroy registry
                raise
            end
        end
    end
end
