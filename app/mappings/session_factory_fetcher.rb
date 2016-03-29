import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.boot.registry.BootstrapServiceRegistryBuilder'
import 'org.hibernate.boot.MetadataSources'

ActiveSupport.on_load :hibernate_session_factory do
    # TODO: This is triggering on any code change
    puts 'reload!'
    # if self.respond_to?(:reset_session_factory)
    #     puts 'resetting session_factory'
    #     self.reset_session_factory
    # end
end

class SessionFactoryFetcher
    ActiveSupport.run_load_hooks(:hibernate_session_factory, self)

    def self.reset_session_factory
        @session_factory = nil
    end

    def self.session_factory
        @session_factory ||= begin
            puts 'rebuilding session factory'
            # TODO: Map ruby types to java ones with some fluent mapping code??
            fields = {
                id: 'java.lang.Long',
                desc: 'java.lang.String',
                greetings: 'java.util.Collection'
            }
            # TODO: Find models automatically
            ModelAnnotator.annotate(Bsw::Event, fields)
            fields = {
                id: 'java.lang.Long',
                greeting: 'java.lang.String'
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
