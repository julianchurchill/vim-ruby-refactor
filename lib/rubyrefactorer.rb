
# 1 based - to match Vims notion of ranges
class Range
  attr_reader :start_line, :end_line, :start_character, :end_character

  def initialize sl, sc, el, ec
    @start_line = sl
    @start_character = sc
    @end_line = el
    @end_character = ec
  end
end

class RubyRefactorer
  def extract_method name, buffer, range
    (range.start_line..range.end_line).each do |line_number|
      line = ""
      if line_number == range.start_line
        line = extract_line_start buffer[ line_number ], range
      end
      if line_number == range.end_line
        line += extract_line_end buffer[ line_number ], range
      end
      buffer[ line_number ] = line
    end
  end

  def extract_line_start line, range
    turn_nil_to_blank_string line[0...range.start_character-1]
  end

  def turn_nil_to_blank_string string
    return "" if string == nil
    string
  end

  def extract_line_end line, range
    turn_nil_to_blank_string line[range.end_character..-1]
  end
end

