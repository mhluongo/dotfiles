" hq keyword highlighting — only in ~/Sync/scratch/notes/
" Keywords defined in crates/hq-core/src/keyword.rs
" Update here when adding new keywords to hq-core

highlight HqBang ctermfg=203 guifg=#f7768e cterm=bold gui=bold
highlight HqKeyword ctermfg=75 guifg=#7aa2f7 cterm=bold gui=bold

function! s:HqHighlight()
  if &filetype !=# 'markdown'
    return
  endif
  if resolve(expand('%:p')) !~# '^' . expand('~') . '/Sync/scratch/notes/'
    return
  endif
  if get(w:, 'hq_keywords_loaded', 0)
    return
  endif
  let w:hq_keywords_loaded = 1

  " Bang variants (priority 11 — wins over regular)
  call matchadd('HqBang', '@delegate!', 11)
  call matchadd('HqBang', '@share!', 11)

  " Regular keywords (priority 10)
  call matchadd('HqKeyword', '@delegate', 10)
  call matchadd('HqKeyword', '@1:1', 10)
  call matchadd('HqKeyword', '@share', 10)
  call matchadd('HqKeyword', '@remind', 10)
  call matchadd('HqKeyword', '@project', 10)
  call matchadd('HqKeyword', '@customer', 10)
  call matchadd('HqKeyword', '@kaizen', 10)
endfunction

augroup HqKeywords
  autocmd!
  autocmd VimEnter,BufReadPost,BufEnter *.md call s:HqHighlight()
augroup END
