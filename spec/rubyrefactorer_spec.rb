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
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "12345678"
    r = RubyRefactorer.new

    range = Range.new 2, 3, 2, 6
    r.extract_method "new_method_name", buffer, range

    buffer[1].should == ""
    buffer[2].should == "1278"
  end

  it "should cut whole lines from multi line highlighted text" do
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "12345678"
    buffer[3] = "abcdefgh"
    buffer[4] = "abcdefgh"
    r = RubyRefactorer.new

    range = Range.new 2, Range::MIN_COLUMN, 4, Range::BEYOND_MAX_COLUMN 
    r.extract_method "new_method_name", buffer, range

    buffer[1].should == ""
    buffer[2].should_not == "12345678"
    buffer[3].should_not == "abcdefgh"
    buffer[4].should_not == "abcdefgh"
  end

  it "should join partial lines that are included in the highlighted text" do
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "12345678"
    buffer[3] = "abcdefgh"
    r = RubyRefactorer.new

    range = Range.new 2, 5, 3, 4
    r.extract_method "new_method_name", buffer, range

    buffer[1].should == ""
    buffer[2].should == "1234efgh"
    buffer[3].should_not == "abcdefgh"
  end

  it "should paste the highlighted text after the new function definition"
  it "should include the function arguments in the definition"
  it "should postfix the end keyword with an additional newline after the new function"
  it "should replace the highlighted text with a call to the new function"
end
