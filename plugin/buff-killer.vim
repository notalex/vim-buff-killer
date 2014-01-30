"private {{{
  function! s:MatchingBufferIndexes(pattern)
    let l:very_magic_pattern = '\v' . a:pattern
    let l:indexes = []

    for buf_index in range(1, bufnr('$'))
      let l:buffer_name = bufname(buf_index)
      let l:buffer_file_name = matchstr(l:buffer_name, '\v[^/]+$')

      if strlen(matchstr(l:buffer_file_name, l:very_magic_pattern))
        call add(l:indexes, buf_index)
      endif
    endfor

    return l:indexes
  endfunction

  function! s:OtherIndexes(indexes)
    let l:indexes = []

    for buf_index in range(1, bufnr('$'))
      if index(a:indexes, buf_index) < 0
        call add(l:indexes, buf_index)
      endif
    endfor

    return l:indexes
  endfunction

  function! s:DeletableBufferIndexes(retain_buffers)
    let l:indexes = []

    for buf_index in range(1, bufnr('$'))
      if bufloaded(buf_index) && index(a:retain_buffers, buf_index) < 0
        call add(l:indexes, buf_index)
      endif
    endfor

    return l:indexes
  endfunction
"}}}

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

function! s:DeleteBuffersRetainPattern(pattern)
  let l:matching_indexes = <SID>MatchingBufferIndexes(a:pattern)

  call <SID>DeleteOtherBuffers(l:matching_indexes)
endfunction

function! s:DeleteBuffersPattern(pattern)
  let l:matching_indexes = <SID>MatchingBufferIndexes(a:pattern)
  let l:non_matching_indexes = <SID>OtherIndexes(l:matching_indexes)

  call <SID>DeleteOtherBuffers(l:non_matching_indexes)
endfunction

command! BdAll call <SID>DeleteBuffers()
command! BdOthers call <SID>DeleteOtherBuffers([bufnr('%')])
command! -nargs=1 BdRetainPattern call <SID>DeleteBuffersRetainPattern(<f-args>)
command! -nargs=1 BdPattern call <SID>DeleteBuffersPattern(<f-args>)
