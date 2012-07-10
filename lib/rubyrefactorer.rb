
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
    old_line = buffer[ range.start_line ]
    before = old_line[0...range.start_character-1]
    after = old_line[range.end_character..-1]
    before = "" if before == nil
    after = "" if after == nil
    buffer[ range.start_line ] = before + after
  end
end

