module ExceptionDetails

	module InspectVariables

	 SCOPES = [:local_variables, :instance_variables, :class_variables]

	 private

		# for each variable scope, build an array of strings displaying values in that scope
		def dump_variables(target_binding, variable_type)
			variable_strings = []
			return ["exception_details: Variable inspection unavailable (no binding)"] if target_binding.nil?
			if target_binding.eval("respond_to?(:#{variable_type}, true)")
				variable_names = target_binding.eval(variable_type.to_s)
				variable_names.each do |vname|
					value = target_binding.eval(vname.to_s)
					variable_value_string = "<#{value.class}> #{vname} = #{value.inspect}"
					variable_strings << variable_value_string
				end
			end
			variable_strings
		end

		def variable_inspect_string(target_binding, opts = {})
			if opts[:scopes]
				scopes = [opts[:scopes]].flatten
			end
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