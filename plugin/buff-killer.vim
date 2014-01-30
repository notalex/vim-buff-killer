function! s:DeletableBufferIndexes()
  let l:indexes = []

  for buf_index in range(1, bufnr('$'))
    if bufloaded(buf_index)
      call add(l:indexes, buf_index)
    endif
  endfor

  return l:indexes
endfunction

function! s:DeleteOtherBuffers()
  let l:deleteable_buffer_indexes = <SID>DeletableBufferIndexes()

  for buf_index in l:deleteable_buffer_indexes
    execute 'bdelete ' . buf_index
  endfor

  echom len(l:deleteable_buffer_indexes) . ' buffers deleted!'
endfunction

function! s:DeleteBuffers()
  call <SID>DeleteOtherBuffers()
endfunction

command! BdAll call <SID>DeleteBuffers()
