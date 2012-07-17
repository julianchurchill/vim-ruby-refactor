require 'variableextractor.rb'

describe "VariableExtractor" do
  it "should be able to extract variables from a boolean conditional" do
    v = VariableExtractor.new [ "a == b" ]
    v.extract.should == [ "a", "b" ]
  end

  it "should be able to extract variables from a multi line boolean conditional" do
    v = VariableExtractor.new [ "a ==", "b" ]
    v.extract.should == [ "a", "b" ]
  end
end
