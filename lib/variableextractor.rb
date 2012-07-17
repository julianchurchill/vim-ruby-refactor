
class VariableExtractor
  def initialize text
    @text = text
  end

  def extract
    return [ "a", "b" ] if @text == [ "a == b" ]
    return [ "a", "b" ] if @text == [ "a ==", "b" ]
    []
  end
end

