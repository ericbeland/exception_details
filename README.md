# Exception Details

Exception Details causes instances of Exception to capture a binding at creation-time.
It provides convenience methods on Exceptions to inspect all the variables and values
from the time of the Exception and adds an informative log string.

Features/benefits:

	* Get detail (variables/values) about your Exception circumstances **without** reproducing it.

	* Reduced need for debug/logging code to find out what went wrong.

	* Minimize ambiguous errors (which variable was nil?).

	* A single method for a loggable string (avoid repeating exception log string creation)

	* Log Pry-like debug info from cron errors and running systems without being there.

	* Debug information with less fewer dependencies--binding_of_caller is the only dependency.


## Example Usage

	greeting = 'hello'
	@name = nil

	begin
		puts greeting + @name
	rescue Exception => e
		puts e.details
		puts e.inspect_variables
	end

	e.details ->

		Exception:
			TypeError: can't convert nil into String
		Variables:
			<String> greeting                   = "hello"
			<NilClass> @name                    = nil

		Backtrace:
			/Users/me/apps/exception_details/spec/exception_details_spec.rb:20:in `+'
		/Users/me/apps/exception_details/spec/exception_details_spec.rb:20:in `block (3 levels) in <top (required)>'
		/Users/me/.rvm/gems/ruby-1.9.3-p374/gems/rspec-core-2.14.3/lib/rspec/core/example.rb:114:in `instance_eval'
		and so forth ...


	e.inspect_variables ->

		<String> greeting = "hello"
		<TypeError> e = #<TypeError: can't convert nil into String>
		<NilClass> @name = nil

Or access the variables in the binding yourself...

	e.binding_during_exception.eval("puts #{greeting}")

## Filtering

If you need to hide certain variable values, such as passwords, private keys,
etc., you can configure an array of variable names to be filtered. Symbols
or strings may be used. The filter settings are global across all exceptions.

	Exception.filter_variables = [:password, :username, :enjoys_php]

## Installation

Add to your Gemfile:

    gem 'exception_details'

Execute:

    $ bundle

Require it:

	require 'exception_details'

## Limitations
- This gem requires [binding\_of\_caller](https://github.com/banister/binding_of_caller), so it should only work with MRI 1.9.2, 1.9.3, 2.0
and RBX (Rubinius). Does not work in 1.8.7, but there is a well known (continuation-based)
hack to get a Binding#of_caller there. There is some mention about binding of caller supporting
jruby, so feel free to try it out.

* Getting a binding from a NameError seems to be problematic.

* This gem is still new...

* binding_of_caller is experiencing some segfault issues on some rubies, so this is not
  ideal for a production stack...  Shame, as how awesome would using this in production be?

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
