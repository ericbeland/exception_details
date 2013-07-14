# ExceptionDetails

Exception Details extends the Ruby Exception class to give you access to the binding
at the time of an exception. It also provides convenience methods to inspect all the
variables in scope, and to output an informative log string.

## Installation

Add to your Gemfile:

    gem 'exception_details'

Execute:

    $ bundle

Require it:

	require 'exception_details'

## Usage

begin
	mood = 'good'
	time = 'morning'
	@name = nil
	p mood + time + name
rescue Exception => e
	p e.inspect_variables
end





## Limitations
This gem requires binding_of_caller, so it only works with MRI 1.9.2, 1.9.3, 2.0
and RBX (Rubinius). Does not work in 1.8.7, but there is a well known (continuation-based)
hack to get a Binding#of_caller there.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
