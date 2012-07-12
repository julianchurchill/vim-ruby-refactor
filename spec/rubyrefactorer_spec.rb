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
  VIM_FULL_LINE_SELECTION_COLUMN_START = 1
  VIM_FULL_LINE_SELECTION_COLUMN_END = 2147483647

  it "should cut single line highlighted text from the vim buffer" do
    buffer = double( 'current vim buffer' )
    buffer.stub( :[] ).with( 2 ).and_return( "12345678" )
    buffer.should_receive( :[]= ).with( 2, "1278" )
    r = RubyRefactorer.new

    range = Range.new 2, 3, 2, 6
    r.extract_method "new_method_name", buffer, range
  end

  it "should cut multi line highlighted text from the vim buffer" do
    buffer = double( 'current vim buffer' )
    buffer.stub( :[] ).with( 2 ).and_return( "12345678" )
    buffer.stub( :[] ).with( 3 ).and_return( "abcdefgh" )
    buffer.should_receive( :[]= ).with( 2, "12" )
    buffer.should_receive( :[]= ).with( 3, "gh" )
    r = RubyRefactorer.new

    range = Range.new 2, 3, 3, 6
    r.extract_method "new_method_name", buffer, range
  end

  it "should cut whole lines from multi line highlighted text from the vim buffer with extreme ranges" do
    buffer = double( 'current vim buffer' )
    buffer.stub( :[] ).with( 2 ).and_return( "12345678" )
    buffer.stub( :[] ).with( 3 ).and_return( "abcdefgh" )
    buffer.stub( :[] ).with( 4 ).and_return( "abcdefgh" )
    buffer.should_receive( :delete ).with( 2 )
    buffer.should_receive( :delete ).with( 3 )
    buffer.should_receive( :delete ).with( 4 )
    r = RubyRefactorer.new

    range = Range.new 2, VIM_FULL_LINE_SELECTION_COLUMN_START, 4, VIM_FULL_LINE_SELECTION_COLUMN_END
    r.extract_method "new_method_name", buffer, range
  end

  it "should join partial lines that are included in the highlighted text"
  it "should paste the highlighted text after the current function"
  it "should precede the pasted text with a new line and the function definition"
  it "should include the function arguments in the definition"
  it "should postfix the end keyword with an additional newline after the new function"
  it "should replace the highlighted text with a call to the new function"
end
