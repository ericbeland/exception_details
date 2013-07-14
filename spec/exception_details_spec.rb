require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'exception_details'

describe "ExceptionDetails" do

  before(:each) do
    v         = VariableScopeTestObject.new
    @e        = v.make_exception
    @class_e  = VariableScopeTestObject.make_class_level_exception
  end

  context ".details" do
    it "should provide exception details method with back trace" do
      @e.details.include?('.rb').should be_true
    end

    it "should provide exception message" do
      @e.details.include?(@e.message).should be_true
    end

    it "should include inspect_variables output" do
      @e.details.include?(@e.inspect_variables).should be_true
    end

  end

  context "exception detail functions" do

    it "should be available on exceptions created by raise and a string" do
      begin
        raise "Foo"
      rescue Exception => e
        e.binding_during_exception.should be_an_instance_of Binding
      end
    end

    it "should be available on Exceptions" do
      reality_check = true
      e = Exception.new
      e.binding_during_exception.should be_an_instance_of Binding
      e.inspect_variables.include?("reality_check").should be_true
    end

    it "should be available on subclasses of exception like Standard Error" do
      reality_check = true
      e = StandardError.new
      e.binding_during_exception.should be_an_instance_of Binding
      e.inspect_variables.include?("reality_check").should be_true
     # end
    end

    it "should be available on grandchild subclasses" do
      begin
        # cause an arugument error
        should_be_in_output = true
        "UP".downcase("", "")
      rescue Exception => e
        e.binding_during_exception.should be_an_instance_of Binding
        e.inspect_variables.include?("should_be_in_output").should be_true
       end
    end

    pending "Need to investigate why NameError won't capture a binding (any takers?)" do
      it "should capture a binding for NameError" do
        begin
          reality_check = true
          'hello' + made_up_variable
        rescue Exception =>e
          e.binding_during_exception.should be_an_instance_of Binding
          e.inspect_variables.include?("reality_check").should be_true
        end
      end
    end

  end

  context "inspect variables" do

    it "should include variable values" do
      @e.inspect_variables.include?('1nstance').should be_true
      @e.inspect_variables.include?('1ocal').should be_true

      @class_e.inspect_variables.include?('c1ass').should be_true
    end

    it "should include variable names" do
      names = %w{@instance local @@class}
      @e.inspect_variables.include?('@instance').should be_true
      @e.inspect_variables.include?('local').should be_true

      @class_e.inspect_variables.include?('@@class').should be_true
    end

    it "should not include global variables by default" do
      @e.details.include?('g1obal').should be_false
    end

    it "should let me select scopes" do
      d = @e.details(:scopes => :local_variables)
      @e.details(:scopes => :local_variables).include?('1nstance').should be_false
      @e.details(:scopes => :class_variables).include?('g1obal').should be_false
    end

  end

end