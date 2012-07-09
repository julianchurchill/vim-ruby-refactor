
class RubyRefactorer
  def extract_method
    @buffer = VIM::Buffer.current
    @buffer.append( @buffer.count, VIM::evaluate( 'name' ) )
  end
end

