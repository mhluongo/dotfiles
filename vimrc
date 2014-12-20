execute pathogen#infect()
syntax on
filetype plugin indent on

highlight clear SignColumn
highlight link GitGutterAdd LineNr
highlight link GitGutterChange LineNr
highlight link GitGutterDelete LineNr

" Remove trailing whitespace on write
autocmd BufWritePre * :%s/\s\+$//e
