function! s:DeletableBufferIndexes(retain_buffers)
  let l:indexes = []

  for buf_index in range(1, bufnr('$'))
    if bufloaded(buf_index) && index(a:retain_buffers, buf_index) < 0
      call add(l:indexes, buf_index)
    endif
  endfor

  return l:indexes
endfunction

function! s:DeleteOtherBuffers(retain_buffers)
  let l:deleteable_buffer_indexes = <SID>DeletableBufferIndexes(a:retain_buffers)

  for buf_index in l:deleteable_buffer_indexes
    execute 'bdelete ' . buf_index
  endfor

  echom len(l:deleteable_buffer_indexes) . ' buffers deleted!'
endfunction

function! s:DeleteBuffers()
  call <SID>DeleteOtherBuffers([0])
endfunction

command! BdAll call <SID>DeleteBuffers()
command! BdOthers call <SID>DeleteOtherBuffers([bufnr('%')])
