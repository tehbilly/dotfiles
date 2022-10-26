" vim-plug
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-git'
Plug 'chriskempson/base16-vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'LnL7/vim-nix'
Plug 'NoahTheDuke/vim-just'

call plug#end()

" Basic setup
set nocompatible
filetype off

filetype plugin indent on

if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Other general settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" Fast editing of the .vimrc
map <leader>e :e! ~/.vimrc<cr>

" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vimrc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertical..
set so=7

set ruler "Always show current position
"set cmdheight=2 "The commandbar height
set hid "Change buffer - without saving
set nu "Show line numbers

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase "Ignore case when searching
set smartcase

set hlsearch "Highlight search things

set incsearch "Make search act like search in modern browsers
set nolazyredraw "Don't redraw while executing macros

set magic "Set magic on, for regular expressions

set showmatch "Show matching bracets when text indicator is over them
set mat=2 "How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

set lbr
set tw=500

"set ai "Auto indent
"set si "Smart indet
"set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set font and shell
set gfn=Monospace\ 10

set t_Co=256
set encoding=utf8

try
    lang en_US
catch
endtry

set ffs=unix,dos,mac "Default file types
syntax enable "Enable syntax hl

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Random useful stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tab configuration
map <leader>tn :tabnew<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>

set mouse=a

" vim-airline settings
" let g:airline#extensions#tabline#enabled = 1
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = '|'
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = '|'
set laststatus=2
set noshowmode

" Open NERDTree if no file(s) were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close vim if NERDTree is the last window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERDTree Settings
let NERDTreeNaturalSort = 1
let NERDTreeShowHidden = 1

