require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'exception_details'

describe "ExceptionDetails" do

  before(:each) do
    v         = VariableScopeTestObject.new
    @e        = v.make_exception
    @class_e  = VariableScopeTestObject.make_class_level_exception
  end

  def duh(arg)
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

    it "sdfsd" do
      begin
        mood = 'good'
        time = 'morning'
        #@name = nil
      #  raise "Helllo"
    #  duh(1,2)
        p mood + time + lklkname
      rescue Exception => e
      #  binding.pry
        p e.inspect_variables
      end
    end

  end

  context "inspect variables" do

    # it "should include variable values" do
    #   @e.inspect_variables.include?('1nstance').should be_true
    #   @e.inspect_variables.include?('1ocal').should be_true

    #   @class_e.inspect_variables.include?('c1ass').should be_true
    # end

    # it "should include variable names" do
    #   names = %w{@instance local @@class}
    #   @e.inspect_variables.include?('@instance').should be_true
    #   @e.inspect_variables.include?('local').should be_true

    #   @class_e.inspect_variables.include?('@@class').should be_true
    # end

    # it "should not include global variables by default" do
    #   @e.details.include?('g1obal').should be_false
    # end

    # it "should let me select scopes" do
    #   d = @e.details(:scopes => :local_variables)
    #   @e.details(:scopes => :local_variables).include?('1nstance').should be_false
    #   @e.details(:scopes => :class_variables).include?('g1obal').should be_false
    # end

  end

end