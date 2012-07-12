
# 1 based - to match Vims notion of ranges
class Range
  MIN_COLUMN = 1
  BEYOND_MAX_COLUMN = 2147483647
  attr_reader :start_line, :end_line, :start_character, :end_character

  def initialize sl, sc, el, ec
    @start_line = sl
    @start_character = sc
    @end_line = el
    @end_character = ec
  end

  def whole_line_is_in_range? line_number
    line_internal_to_range? line_number or
    whole_start_line_is_in_range? line_number or
    whole_end_line_is_in_range? line_number
  end

  def line_internal_to_range? line_number
      line_number != @start_line and line_number != @end_line
  end

  def whole_start_line_is_in_range? line_number
      line_number == @start_line and @start_character == Range::MIN_COLUMN and line_number != @end_line
  end

  def whole_end_line_is_in_range? line_number
      line_number == @end_line and @end_character == Range::BEYOND_MAX_COLUMN and line_number != @start_line
  end
end

class RubyRefactorer

  def initialize
    @lines_to_delete = []
  end

  def extract_method name, buffer, range
    @buffer = buffer
    @range = range
    (@range.start_line..@range.end_line).each do |line_number|
      remove_highlighted_part_of_line line_number
    end
    remove_lines_scheduled_for_delete
  end

  def remove_highlighted_part_of_line line_number
    if @range.whole_line_is_in_range? line_number
      @lines_to_delete += [ line_number ]
    else
      remove_partially_highlighted_line line_number
    end
  end

  def remove_partially_highlighted_line line_number
    line = ""
    if line_number == @range.start_line
      line = extract_line_start @buffer[ line_number ]
    end
    if line_number == @range.end_line
      line += extract_line_end @buffer[ line_number ]
    end
    @buffer[ line_number ] = line
  end

  def remove_lines_scheduled_for_delete
    total_lines_deleted = 0
    @lines_to_delete.each do |line_number|
      @buffer.delete( line_number - total_lines_deleted )
      total_lines_deleted += 1
    end
  end

  def extract_line_start line
    turn_nil_to_blank_string line[0...@range.start_character-1]
  end

  def turn_nil_to_blank_string string
    return "" if string == nil
    string
  end

  def extract_line_end line
    turn_nil_to_blank_string line[@range.end_character..-1]
  end
end

