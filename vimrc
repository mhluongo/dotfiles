execute pathogen#infect()

" vim-plug
call plug#begin('~/.vim/plugged')

Plug 'yuezk/vim-js'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jacqueswww/vim-vyper'
Plug 'jason0x43/vim-js-indent'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Quramy/tsuquyomi'
Plug 'thesis/vim-solidity'

call plug#end()

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

" Open new windows at the bottom
set splitbelow

" character counts at the bottom, etc
set ruler

" backspace over everything in insert mode
set backspace=indent,eol,start

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

" Tab renaming
command -nargs=+ Tr :TabooRename <args>

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

if has('python')
    python << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
elseif has('python3')
    python3 << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif

" Two-tab indents for JS
"
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType typescript setlocal ts=2 sts=2 sw=2 expandtab

" Disable the vim-typescript indenter in favor of vim-js-indent

let g:typescript_indent_disable = 1

" Use tsuquyomi for typescript completion

autocmd FileType typescript setlocal completeopt-=menu

" Highlight .jsx and .tsx files as .tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif
