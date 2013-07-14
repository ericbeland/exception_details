require_relative '../exception_details'

# Extend the Ruby Exception class with our helper methods.
class Exception
	include ExceptionDetails::InspectVariables

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
	def details(opts = {})
		inspect_results = inspect_variables(opts)
		"Exception:\n#{message}\n\nVariables:\n#{inspect_results}\n\nBacktrace:\n#{backtrace.to_a.join("\n")}"
	end

	class << self
		alias :__new__ :new

		def inherited(subclass)
      puts "#{subclass} has inherited #{self}"
      class << subclass
        alias :new :__new__
      end
    end

	end

		# override the .new method on exception to grab the binding where the exception occurred.
		def self.new(*args)
			p "Called my new for #{self.name}"
			p "b #{binding.of_caller(1)}"
			e = __new__(*args)
			e.binding_during_exception = binding.of_caller(1)
			e
		end

end