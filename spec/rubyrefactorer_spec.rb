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

    def append index, content
      @lines.insert rebase( index ) + 1, content
    end

    def []= index, content
      @lines[rebase index] = content
    end

    def [] index
      @lines[rebase index]
    end

    def delete index
      @lines.delete_at rebase index
    end

    private

    def rebase index
      index - 1
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
    buffer[2].should_not == "12345678"
    buffer[2].should =~ /^12.*78$/
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
    buffer[2].should_not == "12345678"
    buffer[2].should =~ /^1234.*efgh$/
    buffer[3].should_not == "abcdefgh"
  end

  it "should add a new line with the function definition immediately after the highlighted text" do
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "12345678"
    buffer[3] = "abcdefgh"
    r = RubyRefactorer.new

    range = Range.new 2, 5, 3, 4
    r.extract_method "new_method_name", buffer, range

    buffer[3].should == "def new_method_name"
  end

  it "should paste the multiline highlighted text after the new function definition" do
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "12345678"
    buffer[3] = "abcdefgh"
    buffer[4] = "ijklmnop"
    r = RubyRefactorer.new

    range = Range.new 2, 5, 4, 4
    r.extract_method "new_method_name", buffer, range

    buffer[4].should == "5678"
    buffer[5].should == "abcdefgh"
    buffer[6].should == "ijkl"
  end

  it "should paste the single line highlighted text after the new function definition" do
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "12345678"
    r = RubyRefactorer.new

    range = Range.new 2, 3, 2, 6
    r.extract_method "new_method_name", buffer, range

    buffer[4].should == "3456"
  end

  it "should postfix the end keyword on a new line after the new function" do
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "12345678"
    r = RubyRefactorer.new

    range = Range.new 2, 3, 2, 6
    r.extract_method "new_method_name", buffer, range

    buffer[r.new_method_end_line].should == "end"
  end

  it "new function should not overwrite lines after the highlighted text" do
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "12345678"
    buffer[3] = "abcdefgh"
    r = RubyRefactorer.new

    range = Range.new 2, 3, 2, 6
    r.extract_method "new_method_name", buffer, range

    buffer[r.new_method_end_line+1].should == "abcdefgh"
  end

  it "should replace the single line highlighted text with a call to the new function" do
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "12345678"
    r = RubyRefactorer.new

    range = Range.new 2, 3, 2, 6
    r.extract_method "new_method_name", buffer, range

    buffer[2].should == "12new_method_name78"
  end

  it "should replace the multi line highlighted text with a call to the new function" do
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "12345678"
    buffer[3] = "abcdefgh"
    r = RubyRefactorer.new

    range = Range.new 2, 3, 3, 6
    r.extract_method "new_method_name", buffer, range

    buffer[2].should == "12new_method_namegh"
  end

  it "should include the method arguments in the definition" do
    buffer = VIM::Buffer.new
    buffer[1] = ""
    buffer[2] = "a == b"
    r = RubyRefactorer.new

    range = Range.new 2, 1, 2, 6
    r.extract_method "new_method_name", buffer, range

    buffer[3].should == "def new_method_name a b"
  end

  it "should include the method arguments in the method call"
end
