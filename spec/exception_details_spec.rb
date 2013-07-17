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
        # cause an argument error
        should_be_in_output = true
        "UP".downcase("", "")
      rescue Exception => e
        e.binding_during_exception.should be_an_instance_of Binding
        e.inspect_variables.include?("should_be_in_output").should be_true
       end
    end


    it "should capture a binding for NameError" do
    pending "Need to investigate why NameError won't capture a binding (any takers?)"
      begin
        reality_check = true
        'hello' + made_up_variable
      rescue Exception => e
        p e.inspect
        e.binding_during_exception.should be_an_instance_of Binding
        e.inspect_variables.include?("reality_check").should be_true
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

  context "variable value filtering" do
    before :each do
      Exception.filter_variables = [:hideme]
    end

    it "should let you configure filter variables on the Exception class" do
      Exception.respond_to?(:filter_variables).should be_true
      StandardError.respond_to?(:filter_variables).should be_true
   end

    it "should convert filter_variable names to strings on assignment" do
      Exception.filter_variables = [:foo]
      Exception.filter_variables.should == ['foo']
    end

    it "should share all assigned filtering across all exception classes" do
      Exception.filter_variables = [:hello]
      (Exception.filter_variables == ['hello']).should be_true
      (Exception.filter_variables == StandardError.filter_variables).should be_true
    end

    it "should filter selected variable values" do
      hideme = 'shouldntseeme'
      showme = 'shouldseeme'
      begin
        raise "hell"
      rescue Exception => e
        #variable name still shows up
        e.inspect_variables.include?('hideme').should be_true

        # but not the value
        e.inspect_variables.include?('shouldntseeme').should be_false
        e.inspect_variables.include?('**FILTERED**').should be_true
      end
    end

    it "should not filter other variables" do
      hideme = 'shouldntseeme'
      showme = 'shouldseeme'
      begin
        raise "hell"
      rescue Exception => e
        e.inspect_variables.include?('shouldseeme').should be_true
      end
    end

  end

end