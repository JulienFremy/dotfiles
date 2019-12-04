set nocompatible              " be iMproved, required
"filetype off                  " required if vim < 7.4
set t_Co=256

let g:python3_host_prog=$HOME.'/local/virtualenvs/neovim3/bin/python3'
let g:python_host_prog=$HOME.'/local/virtualenvs/neovim/bin/python'

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
"" The following are examples of different formats supported.
"" Keep Plugin commands between vundle#begin/end.
"" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
"" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
"" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
"" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
"" The sparkup vim script is in a subdirectory of this repo called vim.
"" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}
"
if has('python') || has('python3')
  Plug 'Valloric/YouCompleteMe'
endif
"Plugin 'SirVer/ultisnips'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'terryma/vim-expand-region'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', {'rtp': 'plugin/'}

" All of your Plugins must be added before the following line
call plug#end()            " required
"filetype plugin indent on    " required if vim < 7.4

" Secure options
set exrc
set secure

"enable syntax
syntax on

" airline bar always here
set laststatus=2
let g:airline_theme='cool'
let g:airline#extensions#tabline#enabled = 1

" javacomplete2
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" Leader redefinition
let mapleader = "\<Space>"

" Shortcuts using Leader
" file saving
nnoremap <Leader>w :w<CR>

" copy paste
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Use terryma/vim-expand-region to expand selection
vmap v <Plug>(expand_region_expand)
vmap V <Plug>(expand_region_shrink)

" Disable question for ycm load of conf file
" let g:ycm_confirm_extra_conf = 0
" Path of global ycm conf file
let g:ycm_global_ycm_extra_conf = "~/vim/.ycm_extra_conf.py"

" Format in NORMAL and VISUAL modes
map <C-S-I> :pyf ~/.local/bin/clang-format.py<cr>
" YCM GoTo
nnoremap <M-b> :YcmCompleter GoTo<cr>
" Fuzzy file find
nnoremap <C-k> :FZF<cr>

" Function to open NERDTree on startup
function! StartUp()
if 0 == argc()
        NERDTree
    end
endfunction
" Actual command call
autocmd VimEnter * call StartUp()

" Clang format
function! ClangFormatFile()
  let l:lines="all"
  pyf ~/.local/share/clang/clang-format.py
endfunction
" autocmd BufWritePre *.cpp,*.h,*.c call ClangFormatFile()

map <C-I> :pyf ~/.local/share/clang/clang-format.py<cr>
imap <C-I> <c-o>:pyf ~/.local/share/clang/clang-format.py<cr>

" Remove trailing whitespaces on save
autocmd BufWritePre *.py :%s/\s\+$//e

autocmd FileType python setlocal tabstop=2 shiftwidth=2 softtabstop=0 expandtab smarttab
autocmd FileType txt setlocal tabstop=2 shiftwidth=2 softtabstop=0 expandtab smarttab

autocmd FileType rust setlocal tabstop=2
autocmd FileType rust setlocal softtabstop=2
autocmd FileType rust setlocal expandtab
autocmd FileType rust setlocal shiftwidth=2
autocmd FileType rust setlocal smarttab

autocmd FileType dart setlocal tabstop=2
autocmd FileType dart setlocal softtabstop=2
autocmd FileType dart setlocal expandtab
autocmd FileType dart setlocal shiftwidth=2
autocmd FileType dart setlocal smarttab

autocmd FileType c setlocal tabstop=2
autocmd FileType c setlocal softtabstop=2
autocmd FileType c setlocal expandtab
autocmd FileType c setlocal shiftwidth=2
autocmd FileType c setlocal smarttab

map <C-n> :NERDTreeToggle<CR>


