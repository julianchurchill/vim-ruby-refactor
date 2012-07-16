
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

  def single_line_range?
    @start_line == @end_line
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

class LineConstructor
  def initialize range, buffer, name, line_number
    @range = range
    @buffer = buffer
    @name = name
    @line_number = line_number
  end

  def construct
    line = add_start_of_line
    line += add_method_call
    line += add_end_of_line
    line
  end

  def add_start_of_line
    if @line_number == @range.start_line
      return extract_line_start @buffer[ @line_number ]
    end
    ""
  end

  def extract_line_start line
    turn_nil_to_blank_string line[0...@range.start_character-1]
  end

  def turn_nil_to_blank_string string
    return "" if string == nil
    string
  end

  def add_method_call
    return @name if @range.single_line_range?
    ""
  end

  def add_end_of_line
    if @line_number == @range.end_line
      return extract_line_end @buffer[ @line_number ]
    end
    ""
  end

  def extract_line_end line
    turn_nil_to_blank_string line[@range.end_character..-1]
  end

end

class RubyRefactorer
  NEW_METHOD_OFFSET_FROM_HIGHLIGHTED_TEXT = 1

  def extract_method name, buffer, range
    @name = name
    @buffer = buffer
    @range = range
    @lines_to_delete = []
    @highlighted_text = []

    remove_highlighted_text
    add_method_definition
    add_method_content
    add_method_end
  end

  def add_method_end
    @buffer.append new_method_end_line-1, "end"
  end

  def new_method_end_line
    new_method_start_line + new_method_content_size + 1
  end

  def new_method_content_size
    @highlighted_text.size
  end

  def add_method_content
    new_method_content_line = new_method_start_line + 1
    @highlighted_text.each do |line|
      @buffer.append new_method_content_line-1, line
      new_method_content_line += 1
    end
  end

  def add_method_definition
    @buffer.append new_method_start_line-1, "def #{@name}"
  end

  def new_method_start_line
    @range.start_line + NEW_METHOD_OFFSET_FROM_HIGHLIGHTED_TEXT
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
      @buffer[ @range.start_line ] += @name
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
      @highlighted_text += [ @buffer[ line_number ] ]
    else
      remove_partially_highlighted_line line_number
    end
  end

  def remove_partially_highlighted_line line_number
    save_highlighted_text line_number
    l = LineConstructor.new @range, @buffer, @name, line_number
    @buffer[ line_number ] = l.construct
  end

  def save_highlighted_text line_number
    start_highlight = @range.start_character-1
    end_highlight = @range.end_character-1
    if @range.single_line_range?
      @highlighted_text += [ @buffer[ line_number][start_highlight..end_highlight] ]
    elsif line_number == @range.start_line
      @highlighted_text += [ @buffer[ line_number][start_highlight..-1] ]
    elsif line_number == @range.end_line
      @highlighted_text += [ @buffer[ line_number][0..end_highlight] ]
    end
  end

  def remove_lines_scheduled_for_delete
    total_lines_deleted = 0
    @lines_to_delete.each do |line_number|
      @buffer.delete( line_number - total_lines_deleted )
      total_lines_deleted += 1
    end
  end
end

