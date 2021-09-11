colorscheme thestars
set nocompatible
set tabstop=2
set shiftwidth=2
set expandtab
set number
set hlsearch
set incsearch
set statusline=%f
syntax on
nmap <F1> :NERDTreeToggle<CR>

func! WordProcessor()
	colorscheme thestars
	map j gj
	map k gk
	let g:limelight_conceal_ctermfg = 'gray'
	setlocal formatoptions=1
	setlocal noexpandtab
	setlocal wrap
	setlocal linebreak
	set thesaurus+=/home/zalazalaza/.vim/thesaurus/mthesaur.txt
	set complete+=s
	autocmd! User GoyoEnter Limelight
	autocmd! User GoyoLeave Limelight!
	Goyo
endfu
com! WP call WordProcessor()

"Plugins will be loaded to the below directory.
call plug#begin('~/.vim/plugged')

"List of plugins
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'preservim/nerdtree'
Plug 'neovimhaskell/haskell-vim'
call plug#end()

autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
