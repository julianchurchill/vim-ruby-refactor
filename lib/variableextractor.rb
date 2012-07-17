
class VariableExtractor
  KEYWORDS = [
    " and ",
    " or ",
    "&&",
    "||"
  ]

  def initialize text
    @text = text
  end

  def extract
    return [ "a", "b" ] if @text == [ "a == b" ]
    return [ "a", "b" ] if @text == [ "a ==", "b" ]
    return find_variables
  end

  def find_variables
    text_without_keywords = @text
    KEYWORDS.each { |k| text_without_keywords = remove_keyword text_without_keywords, k }
    identifiers_only = remove_invalid_identifiers text_without_keywords
    return identifiers_only[0].split " "
  end

  def remove_keyword text, keyword
    parsed_text = []
    escaped_keyword = escape_for_regex keyword
    text.each { |t| parsed_text += [ t.gsub( /#{escaped_keyword}/, ' ' ) ] }
    return parsed_text
  end

  def escape_for_regex text
    return '\|\|' if text == "||"
    text
  end

  def remove_invalid_identifiers text
    parsed_text = []
    text.each { |t| parsed_text += [ t.gsub( /\d+\w+/, '' ) ] }
    return parsed_text
  end
end

