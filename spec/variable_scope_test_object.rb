class VariableScopeTestObject

  @@class = 'c1ass'
  $global = 'g1obal'

	def initialize
    @instance = '1nstance'
  end

  def make_exception
   local = '1ocal'
   e =  Exception.new("Foo")
   e.set_backtrace(['somemadeupfileforbacktrace.rb:435'])
   e
	end

  def self.make_class_level_exception
   local = '1ocal'
   e =  Exception.new("Foo")
   e.set_backtrace(['somemadeupfileforbacktrace.rb:435'])
   e
  end

end