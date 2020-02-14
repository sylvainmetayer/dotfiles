set encoding=utf-8
set history=5112

" Spaces & tabs
syntax enable		" enable syntax processing
set tabstop=2		" number of visual spaces per TAB
set softtabstop=2	" number of spaces in tab when editing
set expandtab		" tab are spaces
set smartindent

set mouse=a " Use mouse support in XTerm/iTerm.
set visualbell " Suppress audio/visual error bell

" UI config
set number 		    " show line numbers
set showcmd 		" show command in bottom bar
" set cursorline	" highlight current line
set wildmenu		" visual autocomplete for command menu

" Search
set incsearch 		" search as characters are entered
set hlsearch		" highlight matches

let mapleader=","

"w!! for sudo saving
cmap w!! w !sudo tee % >/dev/null

" Remove whitespace on save
autocmd BufRead,BufWritePre,FileWritePre * silent! %s/[\r \t]\+$//
" Reload .vimrc
map <leader>rv  :source ~/.vimrc<CR>
" Easy access to the shell
map <Leader><Leader> :!