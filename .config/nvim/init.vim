let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

set nocompatible
set background=dark
set number

set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent
set mouse=a

call plug#begin('~/.config/nvim/plugged')

    Plug 'kien/ctrlp.vim'
    Plug 'mileszs/ack.vim'
    Plug 'roxma/nvim-yarp'
    Plug 'scrooloose/nerdtree'

    " NOTE: you need to install completion sources to get completions. Check
    " our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
    Plug 'ncm2/ncm2'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-go'
    Plug 'ncm2/ncm2-jedi'
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-pyclang'
    Plug 'ncm2/ncm2-syntax'
    Plug 'Shougo/neco-syntax'

    Plug 'chlorophyllin/vim-bazel'

    " Plug 'chr4/nginx.vim'           " Nginx syntax highlighting
    " Plug 'dylon/vim-antlr'          " Antlr syntax highlighting
    " Plug 'elubow/cql-vim'           " Cassandra Query Language (CQL)
    " Plug 'flammie/vim-conllu'       " CoNLL file format
    " Plug 'hashivim/vim-terraform'   " Terraform syntax highlighting
    " Plug 'keith/swift.vim'
    " Plug 'kelwin/vim-smali'
    " Plug 'martinda/Jenkinsfile-vim-syntax'
    " Plug 'rhysd/vim-llvm'
    " Plug 'tfnico/vim-gradle'        " Android and Java development
    " Plug 'vim-scripts/bnf.vim'
    " Plug 'zchee/vim-flatbuffers'
    " Plug 'neovimhaskell/haskell-vim'

    " TODO: Don't known what this does.
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }

    " (Optional) Multi-entry selection UI.
    "Plug 'junegunn/fzf'
call plug#end()

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANTE: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

syntax on
filetype on
filetype plugin on
filetype indent on

" Save cursor position
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

augroup syntaxHighlighting
    au BufRead,BufNewFile *.raml set filetype=yaml
    au BufRead,BufNewFile *.yml set filetype=yaml

    " Fix YAML indentation and filetype detection for RAML
    au FileType yaml,html,vue,xml setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" Search settings
set smartcase
set incsearch
set hlsearch

" Vim status line and tab line settings
set showtabline=2
set laststatus=2

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#statusline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_extensions = ['term', 'quickfix', 'keymap', 'po', 'branch', 'tabline', 'wordcount', 'whitespace']

" neovim-compiletion-manager
set shortmess+=c

noremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

inoremap <expr> <Tab> pumvisible() ? "\<C-p>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-n>" : "\<S-Tab>"

" Tabs mapping. It is require setting up your terminal emulator to map
" Control-Tab and Control-Shift-Tab to pseudo escape sequences keys
" correspondetly.
noremap <C-n> :tabnew<CR>
noremap !@#control-tab$ :tabn<CR>
noremap !@#control-shift-tab$ :tabp<CR>

set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>

set nowrap
let g:godef_split=2
let g:go_highlight_variable_declarations = 1

" Set up basic folding: za/zc/zo and [z/]z. Type :help fold for details.
set foldmethod=syntax
set nofoldenable

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

" Show trailing whitespace:
match ExtraWhitespace /\s\+$/

" Show trailing whitespace and spaces before a tab:
match ExtraWhitespace /\s\+$\| \+\ze\t/

" Show < or > when characters are not displayed on the left or right.
set list
set listchars=tab:\ \ ,precedes:<,extends:>

let g:lisp_rainbow = 1
