require_relative '../exception_details'

# Extend the Ruby Exception class with our helper methods.
class Exception
	include ExceptionDetails::InspectVariables
	include ExceptionDetails::LogColorHelpers


	 @@filter_variables = []

	 # Configure an array of variable names to obscure during variable inspection.
	 # variables may be either symbols, or strings.
	 # This provides a way to make sure your logs don't have usernames,
	 # passwords, or private keys. Also, beware of hashes containing
	 # keys you want obscured.

	 # Filtered items will show up with variable values like '**FILTERED**'

	 def self.filter_variables=(variable_names_to_filter)
	 	variable_names_to_filter = variable_names_to_filter.map {|v| v.to_s}
	 	@@filter_variables = variable_names_to_filter
	 end

	 def self.filter_variables
	 	@@filter_variables
	 end

	# binding_during_exception lets you actually directly access
	# the exception-time binding.
	attr_accessor :binding_during_exception

	# Provides a string with the variable names and values
	# captured at exception time.
	def inspect_variables(opts = {})
		variable_inspect_string(binding_during_exception, opts)
	end

	# .details provides a fairly complete string for logging purposes.
	# The message, variables in the exception's scope, and their current
	# values are outputted, followed by the whole backtrace.
	# * +options+ - options[:scope] default: [:local_variables, :instance_variables, :class_variables]
	#  						- options[:colorize] true / false. Whether to add color to the output (for terminal/log)
	def details(options = {})
		options = {colorize:  true}.merge(options)
		inspect_results = inspect_variables(options)
		parts = []
		parts << (options[:colorize] ? red('Exception:') : 'Exception:')
		parts << "\t" + "#{self.class.name}: #{message}"
		parts << (options[:colorize] ? red('Variables:') : 'Variables:')
		parts << inspect_results
		parts << (options[:colorize] ? red('Backtrace:') : 'Backtrace:')
		parts << "\t" + backtrace.to_a.join("\n")
		parts.join("\n")
	end

	class << self
		alias :__new__ :new

		def inherited(subclass)
      class << subclass
        alias :new :__new__
      end
    end
	end

		# override the .new method on exception to grab the binding where the exception occurred.
		def self.new(*args, &block)
			e = __new__(*args)
			e.binding_during_exception = binding.of_caller(1)
			e
		end

end