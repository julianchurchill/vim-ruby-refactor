function! ExtractMethod()
    call inputsave()
    let name = input( "Enter function name:" )
    call inputrestore()
ruby << EOF
  @buffer = VIM::Buffer.current
  @buffer.append( @buffer.count, VIM::evaluate( 'name' ) )
EOF
endfunction
