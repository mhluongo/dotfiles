execute pathogen#infect()

" vim-plug
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'mhluongo/vim-emoji-complete'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'yuezk/vim-js'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jacqueswww/vim-vyper'
Plug 'pangloss/vim-javascript'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Quramy/tsuquyomi'
Plug 'thesis/vim-solidity'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'

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

" Code folding
set foldmethod=syntax
set foldlevel=99

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" Save folds when leaving and entering a window
augroup restorefolds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
augroup END

" vim-gitgutter config
highlight clear SignColumn
highlight link GitGutterAdd LineNr
highlight link GitGutterChange LineNr
highlight link GitGutterDelete LineNr
command GitHi GitGutterLineHighlightsToggle " 😏

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

" Two-tab indents for JS and Markdown

autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType typescript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType markdown setlocal ts=2 sts=2 sw=2 expandtab

" Fold colors for Markdown

autocmd FileType markdown hi Folded ctermfg=6
autocmd FileType markdown hi Folded ctermbg=0

" Disable the vim-typescript indenter in favor of vim-javascript

let g:typescript_indent_disable = 1

" Use tsuquyomi for typescript completion

autocmd FileType typescript setlocal completeopt-=menu

" Highlight .jsx and .tsx files as .tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" Statusline customizations
let g:airline_theme='monochrome'
