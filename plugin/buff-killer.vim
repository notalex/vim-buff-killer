function! s:DeleteBuffer(number)
  execute 'bdelete ' . a:number

  let s:deleted_buffer_count += 1
endfunction

function! s:DeleteAllBuffers()
  let l:index = 1
  let s:deleted_buffer_count = 0

  while l:index <= bufnr('$')
    " Deleting *unnamed buffer* incorrectly affects deleted_buffer_count.
    " Avoiding current buffer here prevents *unnamed buffer* from being deleted.
    if bufloaded(l:index) && bufnr('.') != l:index
      call <SID>DeleteBuffer(l:index)
    endif

    let l:index += 1
  endwhile

  call <SID>DeleteBuffer(bufnr('.'))

  echom s:deleted_buffer_count . ' buffers deleted!'
endfunction

command! Bdall call <SID>DeleteAllBuffers()
