set number
set tabstop=4
set laststatus=2
syntax on
"keybindings 
map <C-g> <esc>:GV<enter>
map <C-s> <esc>:wq<enter>
map <C-q> <esc>:q!<enter>
map <C-t> <esc>:NERDTree<enter>
map <C-f> <esc>:fzf<enter>

"syntax highlighting

let python_highlight_all = 1
let Python3Syntax = 1

if filereadable(expand("~/.vimrc.plug"))
	source ~/.vimrc.plug
endif
