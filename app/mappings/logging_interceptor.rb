require 'overrides/for_all'

class LoggingInterceptor < org.hibernate.EmptyInterceptor
    overrides
    def onSave(entity, id, state, property_names, types)
        puts "got call for entity #{entity} prop names #{property_names.to_a}"

        constructor = java.util.HashSet.java_class.constructor(java.util.Collection)
        set = constructor.new_instance(java.util.Arrays.asList(state[1]))
        puts "replacing with #{set}"
        state[1] = set
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
