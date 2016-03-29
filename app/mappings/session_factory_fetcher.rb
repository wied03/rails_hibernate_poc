import 'org.hibernate.boot.registry.StandardServiceRegistryBuilder'
import 'org.hibernate.boot.registry.BootstrapServiceRegistryBuilder'
import 'org.hibernate.boot.MetadataSources'

class SessionFactoryFetcher
    def self.session_factory
        @session_factory ||= begin
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
