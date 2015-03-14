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
