function! ExtractMethod() range
    call inputsave()
    let name = input( "Enter function name:" )
    call inputrestore()
    let visual_column_start = getpos( "'<'" )[2]
    let visual_column_end = getpos( "'>'" )[2]
ruby << EOF
  require 'lib/rubyrefactorer.rb'

  def highlighted_range
    range = Range.new VIM::evaluate( 'a:firstline' ),
                      VIM::evaluate( 'visual_column_start' ),
                      VIM::evaluate( 'a:lastline' ),
                      VIM::evaluate( 'visual_column_end' )
  end

  r = RubyRefactorer.new
  r.extract_method VIM::evaluate( 'name' ), VIM::Buffer.current, highlighted_range
EOF
endfunction
