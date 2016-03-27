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
                date: 'java.util.Date'
            }
            # TODO: Find models automatically
            ModelAnnotator.annotate(Bsw::Event, fields)

            our_loader = ModelClassLoader.new(Bsw::Event)
            bootstrap = BootstrapServiceRegistryBuilder.new
            .applyClassLoader(our_loader)
            .build

            registry = StandardServiceRegistryBuilder.new(bootstrap)
            .configure('/config/hibernate.cfg.xml')
            .build
            begin
                MetadataSources.new(registry).buildMetadata.buildSessionFactory
            rescue
                StandardServiceRegistryBuilder.destroy registry
                raise
            end
        end
    end
end
