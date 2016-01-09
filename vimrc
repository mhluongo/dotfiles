execute pathogen#infect()
syntax on
filetype plugin indent on

" <Leader>
let mapleader=","

" basic tabbing / mouse usage
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a

" character counts at the bottom, etc
set ruler

" code folding
set foldmethod=syntax
set foldlevel=99

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

""""""""""""""""""""""""
" OS-specific settings "
""""""""""""""""""""""""

if filereadable("~/.vimrc-osx")
    source "~/.vimrc-osx"
endif

""""""""""""""""""""""""""""""
" Language-specific settings "
""""""""""""""""""""""""""""""

" Add the activate python virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
