"line
set number 
set scrolloff=5

"tab 
set expandtab
set tabstop=4
set shiftwidth=4

"syntax 
syntax enable 
set smartindent

"search
set incsearch
set hlsearch

"theme
colorscheme desert

"status bar
set noshowmode 
set laststatus=2                                              
let g:currentmode={
      \ 'n'         : 'NORMAL',
      \ 'v'         : 'VISUAL',
      \ 'V'         : 'V-LINE',
      \ "\<C-v>"    : 'V-BLOCK',
      \ 'i'         : 'INSERT',
      \ 'R'         : 'REPLACE',
      \ 'Rv'        : 'rv',
      \ 'c'         : 'COMMAND',
      \ 't'         : 'f',
      \}
"set statusline+=\[%n]
set statusline+=\ %{g:currentmode[mode()]}\ 
set statusline+=\ %f%m%r%h                                     
set statusline+=\ %w\ \                                     
set statusline+=%=
set statusline+=\ %y\ 
set statusline+=\[%l;%c\]\   
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}\ 

"[various]
autocmd FileType * set formatoptions-=cro
set timeoutlen=1000 ttimeoutlen=20
set mouse=a
set whichwrap+=<,>,h,l
set formatoptions-=o
set formatoptions-=r
set showcmd

"different cursors in different modes
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_SR.="\e[3 q"
