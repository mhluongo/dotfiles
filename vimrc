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
Plug 'tpope/vim-classpath'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-clojure-highlight'
Plug 'christianrondeau/vim-base64'
Plug 'junegunn/vim-emoji'
Plug 'kien/rainbow_parentheses.vim'
Plug 'fatih/vim-go'
Plug 'vim-scripts/paredit.vim'
Plug 'gcmt/taboo.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'dense-analysis/ale'
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
  " From https://vi.stackexchange.com/questions/13864/bufwinleave-mkview-with-unnamed-file-error-32
  " view files are about 500 bytes
  " bufleave but not bufwinleave captures closing 2nd tab
  " nested is needed by bufwrite* (if triggered via other autocmd)
  " BufHidden for compatibility with `set hidden`
  autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup end

" vim-gitgutter config
highlight clear SignColumn
highlight link GitGutterAdd LineNr
highlight link GitGutterChange LineNr
highlight link GitGutterDelete LineNr
command GitHi GitGutterLineHighlightsToggle " 😏

" Remove trailing whitespace on write
autocmd BufWritePre * :%s/\s\+$//e

" Find files with Telescope
nnoremap t <cmd>Telescope find_files<cr>

" Tab renaming
command -nargs=+ Tr :TabooRename <args>

" Statusline customizations
let g:airline_theme='monochrome'
set noshowmode

""""""""""""""""""""""""
" OS-specific settings "
""""""""""""""""""""""""

if filereadable("~/.vimrc-osx")
    source "~/.vimrc-osx"
endif

""""""""""""""""""""""""""""""
" Language-specific settings "
""""""""""""""""""""""""""""""

" Configure ALE to lint and auto-format

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\}
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:airline#extensions#ale#enabled = 1

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

" Highlight .jsx and .tsx files as .tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" Two-space indents for JS, TS, TSX, Markdown, and JSON
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType typescript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType typescript.tsx setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType markdown setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab

" Four-space indents for Solidity

autocmd FileType solidity setlocal ts=4 sts=4 sw=4 expandtab

" Fold colors for Markdown

autocmd FileType markdown hi Folded ctermfg=6
autocmd FileType markdown hi Folded ctermbg=0

" Disable the vim-typescript indenter in favor of vim-javascript

let g:typescript_indent_disable = 1

" Use tsuquyomi for typescript completion

autocmd FileType typescript setlocal completeopt-=menu
