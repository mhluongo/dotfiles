execute pathogen#infect()
syntax on
filetype plugin indent on

" basic tabbing / mouse usage
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a

" vim-gitgutter config

highlight clear SignColumn
highlight link GitGutterAdd LineNr
highlight link GitGutterChange LineNr
highlight link GitGutterDelete LineNr

" Remove trailing whitespace on write
autocmd BufWritePre * :%s/\s\+$//e

" Configure CtrlP (https://github.com/kien/ctrlp.vim)
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_extensions = ['line', 'dir']
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
