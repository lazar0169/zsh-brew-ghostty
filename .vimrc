syntax on
set re=0
set number
set cursorline
set shiftwidth=4
set tabstop=4
set smartindent
set autoindent
set expandtab
set scrolloff=10
set nowrap
set incsearch
set ignorecase
set showmode
set showmatch
set hlsearch
set clipboard=unnamed
" Send deletes to the black hole register, keep yanks on the clipboard
nnoremap d "_d
nnoremap D "_D
nnoremap c "_c
nnoremap C "_C
nnoremap x "_x
vnoremap d "_d
vnoremap c "_c
vnoremap p "_dP
nnoremap \\ :nohlsearch<CR>

set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac
set wildmenu
set wildmode=longest:full,full
set termguicolors
set background=dark
colorscheme slate
