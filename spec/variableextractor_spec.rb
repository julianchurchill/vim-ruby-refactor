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

  it "should be able to extract variables from a unary conditionals" do
    v = VariableExtractor.new [ "a and b and c or d && e" ]
    v.extract.should == [ "a", "b", "c", "d", "e" ]
  end

  it "should be able to extract variables from unary conditional without spaces" do
    v = VariableExtractor.new [ "a||b&&c" ]
    v.extract.should == [ "a", "b", "c" ]
  end

  it "should be able to extract variables from an or conditional" do
    v = VariableExtractor.new [ "a || b" ]
    v.extract.should == [ "a", "b" ]
  end

  it "should ignore identifiers beginning with numbers" do
    v = VariableExtractor.new [ "1banana 2apple a" ]
    v.extract.should == [ "a" ]
  end
end
