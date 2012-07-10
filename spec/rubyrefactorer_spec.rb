require 'rubyrefactorer.rb'

module VIM
  class Buffer
    def self.current
      nil
    end

    def count
    end

    def append position, content
    end
  end
end

describe "RubyRefactorer" do
  it "should cut single line highlighted text from the vim buffer" do
    buffer = double( 'current vim buffer' )
    buffer.stub( :[] ).with( 2 ).and_return( "12345678" )
    buffer.should_receive( :[]= ).with( 2, "1278" )
    r = RubyRefactorer.new

    range = Range.new 2, 3, 2, 6
    r.extract_method "new_method_name", buffer, range
  end

  it "should cut multi line highlighted text from the vim buffer"
  it "should paste the highlighted text after the current function"
  it "should precede the pasted text with a new line and the function definition"
  it "should include the function arguments in the definition"
  it "should postfix the end keyword with an additional newline after the new function"
  it "should replace the highlighted text with a call to the new function"
end
