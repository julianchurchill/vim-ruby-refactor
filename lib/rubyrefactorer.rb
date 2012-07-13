
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
    (line_number == @start_line and whole_start_line_is_in_range?) or
    (line_number == @end_line and whole_end_line_is_in_range?)
  end

  def line_internal_to_range? line_number
      line_number != @start_line and line_number != @end_line
  end

  def whole_start_line_is_in_range?
      @start_character == Range::MIN_COLUMN and
      (@start_line != @end_line or @end_character == Range::BEYOND_MAX_COLUMN)
  end

  def whole_end_line_is_in_range?
      @end_character == Range::BEYOND_MAX_COLUMN and
      (@start_line != @end_line or @start_character == Range::MIN_COLUMN)
  end
end

class RubyRefactorer

  def initialize
    @lines_to_delete = []
  end

  def extract_method name, buffer, range
    @buffer = buffer
    @range = range
    remove_highlighted_text
    add_function_definition name
  end

  def add_function_definition name
    @buffer[ @range.start_line + 1 ] = "def #{name}"
  end

  def remove_highlighted_text
    (@range.start_line..@range.end_line).each do |line_number|
      remove_highlighted_part_of_line line_number
    end
    collapse_start_and_end_lines
    remove_lines_scheduled_for_delete
  end

  def collapse_start_and_end_lines
    if start_and_end_lines_need_joining?
      @buffer[ @range.start_line ] += @buffer[ @range.end_line ]
      @lines_to_delete += [@range.end_line]
    end
  end

  def start_and_end_lines_need_joining?
    if not @range.whole_start_line_is_in_range? and
       not @range.whole_end_line_is_in_range? and
       @range.start_line != @range.end_line
       return true
    end
    false
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

