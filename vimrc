syntax on

set number
set relativenumber
set noerrorbells
set scrolloff=16
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set smartcase
set incsearch
set noswapfile
set cursorline
set foldlevel=50

" Change cursor type for modes.
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q"
let &t_SR = "\e[4 q"


call plug#begin('/home/jirka/.vim/plugged')

Plug 'arcticicestudio/nord-vim'

Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ycm-core/YouCompleteMe'

Plug 'vim-python/python-syntax'
Plug 'tmhedberg/SimpylFold'

call plug#end()

augroup nord-overrides
  autocmd!
  autocmd ColorScheme nord highlight Comment        ctermfg=8
  autocmd ColorScheme nord highlight LineNr         ctermfg=8
  autocmd ColorScheme nord highlight EndOfBuffer    ctermfg=0
  autocmd ColorScheme nord highlight CursorLine                 ctermbg=16
  autocmd ColorScheme nord highlight Visual                     ctermbg=6
augroup END

colorscheme nord
set background=dark

let mapleader=' '

let g:netrw_banner = 0
let g:netrw_browse_split = 2

if executable('rg')
    let g:rg_derive_root='true'
endif

let g:ctrlp_user_command=['.git/']

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>v :wincmd v<CR>

nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>

let g:fileExplorer = 0 
let g:undoExplorer = 0
let g:gitExplorer = 0

function! MoveLeftAndBack(command)
        let l:winNumber = winnr()
        execute '1 wincmd w'
        execute a:command
        if a:command == 'q'
            let l:winNumber = l:winNumber - 1
            execute l:winNumber . ' wincmd w'
        endif
endfunction

function! ExplorerCloser() 
    if g:fileExplorer || g:undoExplorer || g:gitExplorer
        let g:fileExplorer = 0
        let g:undoExplorer = 0
        let g:gitExplorer = 0
        call MoveLeftAndBack('q')
    endif
endfunction

function! ExplorerToggle(command, value)
    if a:value
        call MoveLeftAndBack('q')
        return 0
    else 
        call ExplorerCloser()
        call MoveLeftAndBack(a:command)
        call MoveLeftAndBack('vertical resize 30')
        return 1
    endif
endfunction

nnoremap <leader>f  :let g:fileExplorer = ExplorerToggle('wincmd v <bar> Ex', g:fileExplorer)<CR>
nnoremap <leader>u  :let g:undoExplorer = ExplorerToggle('UndotreeShow <bar> UndotreeShow', g:undoExplorer)<CR>
nnoremap <leader>gs :let g:gitExplorer  = ExplorerToggle('vert Git', g:gitExplorer)<CR>

