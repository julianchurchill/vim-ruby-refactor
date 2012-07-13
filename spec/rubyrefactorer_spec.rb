require 'rubyrefactorer.rb'

module VIM
  class Buffer
    def self.current
      nil
    end

    def initialize
      @lines = []
    end

    def count
      @lines.size
    end

    def append position, content
    end

    def []= index, content
      @lines[index-1] = content
    end

    def [] index
      @lines[index-1]
    end

    def delete index
      @lines.delete_at index-1
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

  it "should cut whole lines from multi line highlighted text from the vim buffer with extreme ranges" do
    buffer = double( 'current vim buffer' )
    buffer.stub( :[] ).with( 2 ).and_return( "12345678" )
    buffer.stub( :[] ).with( 3 ).and_return( "abcdefgh" )
    buffer.stub( :[] ).with( 4 ).and_return( "abcdefgh" )
    # Delete line 2 three times because after each delete the indices are renumbered
    buffer.should_receive( :delete ).with( 2 )
    buffer.should_receive( :delete ).with( 2 )
    buffer.should_receive( :delete ).with( 2 )
    r = RubyRefactorer.new

    range = Range.new 2, Range::MIN_COLUMN, 4, Range::BEYOND_MAX_COLUMN 
    r.extract_method "new_method_name", buffer, range
  end

  it "should join partial lines that are included in the highlighted text" do
    #buffer = double( 'current vim buffer' )
    #buffer.stub( :[] ).with( 2 ).and_return( "12345678" )
    #buffer.stub( :[] ).with( 3 ).and_return( "abcdefgh" )
    #buffer.should_receive( :[]= ).with( 2, "1234efgh" )
    #buffer.should_receive( :delete ).with( 3 )
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "12345678"
    buffer[3] = "abcdefgh"
    r = RubyRefactorer.new

    range = Range.new 2, 5, 3, 4
    r.extract_method "new_method_name", buffer, range

    buffer.count.should == 2
    buffer[1].should == ""
    buffer[2].should == "1234efgh"
  end

  it "should paste the highlighted text after the current function"
  it "should precede the pasted text with a new line and the function definition"
  it "should include the function arguments in the definition"
  it "should postfix the end keyword with an additional newline after the new function"
  it "should replace the highlighted text with a call to the new function"
end
