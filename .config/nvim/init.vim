syntax enable
" language C
filetype plugin indent on

" === load plugins ===
runtime! plugins.vim

" === appearance settings ===
set termguicolors
set t_Co=256
let base16colorspace=256
colorscheme gruvbox
set background=dark
set showmode
set showcmd
set number
set cursorline
set scrolloff=10
set laststatus=2
set noshowmode

" background transparent in Neovim
hi Normal guibg=NONE
hi LineNr guibg=NONE
hi NonText guibg=NONE
hi SpecialKey guibg=NONE

" === coding settings ===
set autoindent
set smartindent
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" === serch settings ===
set wrapscan
set showmatch
set ignorecase
set smartcase
set nowrapscan

" === netrw settings ===
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_sizestyle="H"
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_browse_split=3
let g:netrw_winsize = 25
let g:netrw_alto = 1

" toggle netrw with Ctrl-e
let g:NetrwIsOpen=0

function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction

" Add your own mapping. For example:
noremap <silent> <C-E> :call ToggleNetrw()<CR>

" === other settings ===
set autoread
set nobackup
set noswapfile
set viminfo=
set encoding=utf-8
set fileencodings=utf-8,sjis,euc-jp,iso-2022-jp
set fileencoding=utf-8
set fileformat=unix
set list listchars=tab:\▸\-
set clipboard+=unnamedplus
set backspace=indent,start,eol
set wildmode=longest:full,full
set relativenumber
set helplang=ja,en
set undofile
set undodir=~/.config/nvim/undo
set mouse=a

" delete unnecessary spaces on save
autocmd BufWritePre * :%s/\s\+$//ge

" === load setting files ===
runtime! keymaps.vim
