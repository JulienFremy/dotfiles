set nocompatible              " be iMproved, required
"filetype off                  " required if vim < 7.4
set t_Co=256

" set the runtime path to include Vundle and initialize
set rtp+=~/local/vim/Vundle.vim
"call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
call vundle#begin('~/local/vim/')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

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
  Plugin 'Valloric/YouCompleteMe'
endif
"Plugin 'SirVer/ultisnips'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'terryma/vim-expand-region'
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlp.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
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
nnoremap <F2> :YcmCompleter GoTo<cr>
