function! ExtractMethod()
    call inputsave()
    let name = input( "Enter function name:" )
    call inputrestore()
ruby << EOF
  require 'lib/rubyrefactorer.rb'
  r = RubyRefactorer.new
  r.extract_method
EOF
endfunction
