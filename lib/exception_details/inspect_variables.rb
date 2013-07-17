module ExceptionDetails

	# Mixin that provides methods for dumping variables
	module InspectVariables

	 SCOPES = [:local_variables, :instance_variables, :class_variables]

	 private

		# For each variable scope, build an array of strings displaying
		# type, name and value of each variable in that scope
		# * +target_binding+ - Binding context to inspect.
		# * +variable_scope+ - Variable scope to dump. One of :local_variables,
		# 										:instance_variables, :class_variables, :global variables

		def dump_variables(target_binding, variable_scope)
			variable_strings = []
			if target_binding.eval("respond_to?(:#{variable_scope}, true)")
				variable_names = target_binding.eval(variable_scope.to_s)
				variable_names.each do |vname|
					value = target_binding.eval(vname.to_s)
					if self.class.filter_variables.include?(vname.to_s)
						value = '**FILTERED**'
					end
						variable_value_string = "\t" + sprintf("%-35s = %s", "<#{value.class}> #{vname}", value.inspect)

					unless value == self # don't list the exception itself ...
						variable_strings << variable_value_string
					end
				end
			end
			variable_strings.sort
		end

		# Dump all variables and values in selected scopes into a string
		# * +target_binding+ - Binding context to inspect.
		# * +options+ - options[:scope] default: [:local_variables, :instance_variables, :class_variables]
		#  						- :global_variables is valid as well. Can be an array, or single scope-name symbol
		# or an array
		def variable_inspect_string(target_binding, options = {})
			if options[:scopes]
				scopes = [options[:scopes]].flatten
			end
			return ["exception_details: Variable inspection unavailable (no binding captured)"] if target_binding.nil?
			variable_scopes = scopes || SCOPES
			dump_arrays = []
			variable_scopes.each do |variable_scope|
				variable_string_array = dump_variables(target_binding, variable_scope.to_s)
				dump_arrays << variable_string_array if variable_string_array.length > 0
			end
			dump_arrays.join("\n")
		end

	end

end