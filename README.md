# Exception Details Gem

Exception Details extends the Ruby Exception class to capture a binding
at Exception-time. Exception Details provides convenience methods to inspect all the
variables and values from that moment and adds .details to output an informative log string.

Uses/Features:
	- Get detail (variables/values) about your Exception circumstances ~without~ reproducing the problem first.
	- Reduced need for debug/logging code to find out what went wrong.
	- Minimize ambiguous errors (which variable was nil?).
	- A single statement (Exception.details) gives a loggable string (stop repeating exception log string creation)
  - Get pry level debug knowledge from cron job errors and running system logs without being there.
  - Pry type information with less overhead/dependencies--binding_of_caller is the only dependency.

## Installation

Add to your Gemfile:

    gem 'exception_details'

Execute:

    $ bundle

Require it:

	require 'exception_details'

## Example Usage

	begin
		greeting = 'hello'
		@name = nil
		puts greeting + name
	rescue Exception => e
		puts e.details
		puts e.inspect_variables
	end

#	e.details gets you: ->

	Exception:
		can't convert nil into String
	Variables:
		<String>greeting = "hello"
		<TypeError>e = #<TypeError: can't convert nil into String>
		<NilClass>@name = nil
	Backtrace:
		/Users/ebeland/apps/exception_details/spec/exception_details_spec.rb:20:in `+'
	/Users/ebeland/apps/exception_details/spec/exception_details_spec.rb:20:in `block (3 levels) in <top (required)>'
	/Users/ebeland/.rvm/gems/ruby-1.9.3-p374/gems/rspec-core-2.14.3/lib/rspec/core/example.rb:114:in `instance_eval'
	and so forth ...

#	e.inspect_variables gets you ->

		<String>greeting = "hello"
		<TypeError>e = #<TypeError: can't convert nil into String>
		<NilClass>@name = nil

# Or access the variables in the binding directly yourself...

	e.binding_during_exception.eval("puts #{greeting}")



## Limitations
- This gem requires binding_of_caller, so it should only work with MRI 1.9.2, 1.9.3, 2.0
and RBX (Rubinius). Does not work in 1.8.7, but there is a well known (continuation-based)
hack to get a Binding#of_caller there.

- Getting a binding from a NameError seems to be problematic.

- This gem is still new...

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
