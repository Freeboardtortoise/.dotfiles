set number
set tabstop=4
set laststatus=2

if filereadable(expand("~/.vimrc.plug"))
	source ~/.vimrc.plug
endif
