# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exception_details/version'

Gem::Specification.new do |spec|
  spec.name          = "exception_details"
  spec.version       = ExceptionDetails::VERSION
  spec.authors       = ["Eric Beland"]
  spec.email         = ["ebeland@gmail.com"]
  spec.description   = %q{Inspect variables captured at exception-time to get info about your exceptions}
  spec.summary       = %q{TODO: Exception Details extends Exception to let you inspect variable values at exception-time for logging etc.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "binding_of_caller"

end
