require 'overrides/for_all'

class LoggingInterceptor < org.hibernate.EmptyInterceptor
    overrides
    def onSave(entity, id, state, property_names, types)
        puts "got call for entityy #{entity} prop names #{property_names.to_a}"

        #constructor = java.util.HashSet.java_class.constructor(java.util.Collection)
        #set = constructor.new_instance(java.util.Arrays.asList(state[1]))
        #puts "replacing with #{set}"
        #puts "state is #{state[1]}"
        #state[1] = java.util.ArrayList.new(state[1])
        #true
        false

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
