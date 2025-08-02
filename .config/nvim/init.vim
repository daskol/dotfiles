set nocompatible
set background=dark
colorscheme vim

set number
set scrolloff=2
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent
set mouse=a
set formatoptions+=n

" Prefer to use Python 3.
let g:loaded_python3_provider = 0
let g:loaded_pythonx_provider = 0
let g:python_host_prog = '/usr/bin/python3'

call plug#begin('~/.config/nvim/plugged')
    " NOTE Lines below break completion without explicit completion selection.
    " Advanced LSP support
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/nvim-cmp'

    " " Lanaguge Models.
    " Plug 'huggingface/llm.nvim'

    Plug 'kien/ctrlp.vim'
    " Plug 'mileszs/ack.vim'
    " Plug 'roxma/nvim-yarp'
    " Plug 'scrooloose/nerdtree'

    " NOTE: you need to install completion sources to get completions. Check
    " our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
    " Plug 'ncm2/ncm2'
    " Plug 'ncm2/ncm2-bufword'
    " Plug 'ncm2/ncm2-jedi'
    " Plug 'ncm2/ncm2-path'
    " Plug 'ncm2/ncm2-pyclang'
    " Plug 'ncm2/ncm2-syntax'
    " Plug 'Shougo/neco-syntax'

    " Plug 'HiPhish/jinja.vim'
    " Plug 'chlorophyllin/vim-bazel'

    " Plug 'chr4/nginx.vim'           " Nginx syntax highlighting
    " Plug 'dylon/vim-antlr'          " Antlr syntax highlighting
    " Plug 'elubow/cql-vim'           " Cassandra Query Language (CQL)
    " Plug 'flammie/vim-conllu'       " CoNLL file format
    " Plug 'hashivim/vim-terraform'   " Terraform syntax highlighting
    Plug 'jvirtanen/vim-hcl'
    " Plug 'keith/swift.vim'
    " Plug 'kelwin/vim-smali'
    " Plug 'martinda/Jenkinsfile-vim-syntax'
    " Plug 'rhysd/vim-llvm'
    " Plug 'tfnico/vim-gradle'        " Android and Java development
    " Plug 'vim-scripts/bnf.vim'
    " Plug 'zchee/vim-flatbuffers'
    " Plug 'neovimhaskell/haskell-vim'

    " Typesetting.
    Plug 'kaarmu/typst.vim'

    " Formatting.
    " Plug 'darrikonn/vim-gofmt'

    " " TODO: Don't known what this does.
    " Plug 'autozimu/LanguageClient-neovim', {
    "     \ 'branch': 'next',
    "     \ 'do': 'bash install.sh',
    "     \ }

    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'nvim-treesitter/playground'

    " (Optional) Multi-entry selection UI.
    "Plug 'junegunn/fzf'
call plug#end()

source $HOME/.config/nvim/lsp.lua

" enable ncm2 for all buffers
"autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=menuone,noinsert,noselect

syntax on
filetype on
filetype plugin on
filetype indent on

" Save cursor position
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

" Search settings
set smartcase
set incsearch
set hlsearch

" Vim status line and tab line settings
set showtabline=2
set laststatus=2

" neovim-compiletion-manager
set shortmess+=c

" Hover popup window has weird color scheme. Fix it with assigning the same
" normal color scheme to floating windows.
highlight link NormalFloat Normal

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

noremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Map <Esc> to terminal exit command.
tnoremap <Esc> <C-\><C-n>

" Tabs mapping. It is require setting up your terminal emulator to map
" Control-Tab and Control-Shift-Tab to pseudo escape sequences keys
" correspondetly.
noremap <C-n> :tabnew<CR>
noremap !@#control-tab$ :tabn<CR>
noremap !@#control-shift-tab$ :tabp<CR>

set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
set wrap

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

set tags=tags

set autoread

" Setiup CtrtP plugin.
set wildignore+=*/tmp/*,*.so,*.swp,*.pyc,.env/*,*.egg-info/*,*/env/*,*/node_modules/*,*/__pycache__/*,*.tfevents.*,log/*

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](\.(git|hg|svn|egg-info|dvc|env)|build|data|dist|target)$',
    \ 'file': '\v\.(a|so|pyc)$',
    \ }

" Function and autocommand in autogroup for formatting on pre-write event.

func FormatBuffer(formatter)
    if &modified
        let cursor_pos = getpos('.')
        execute ':%!' . a:formatter
        if v:shell_error
            undo
        endif
        call setpos('.', cursor_pos)
    endif
endfunction

function! FormatBufferPy() range
    if !&modified
        return
    endif

    " Save cursor position and window state.
    let l:cur_win = winsaveview()

    " Determine range to format.
    let l:line_ranges = a:firstline . '-' . a:lastline
    let l:cmd = 'yapf --lines=' . l:line_ranges

    " Call YAPF with the current buffer
    let l:lines = systemlist(l:cmd, join(getline(1, '$'), "\n") . "\n")

    " Show location list if formatting error occures. Otherwise, check whether
    " location list exists then close it if the list exists.
    if v:shell_error
        echohl ErrorMsg
        echomsg printf('ERROR "%s" returned error: "%s"', l:cmd, l:lines[-1])
        echohl None

        let l:filename = expand('%')
        let l:lineno = str2nr(matchlist(l:lines[-4], 'line \(\d\+\)$', 1)[1])
        let l:colidx = matchstrpos(l:lines[-2], '\^')[1]

        call setloclist(0, [], 'r', {
            \ 'title': 'YAPF Errors',
            \ 'context': 'yapf',
            \ })

        call setloclist(0, [{
            \ 'col': l:colidx,
            \ 'filename': l:filename,
            \ 'lnum': l:lineno,
            \ 'text': l:lines[-1],
            \ 'type': 'E',
            \ 'vcol': 1,
            \ }], 'a')

        " Show only one error and exit.
        " lopen 1  " XXX Uncomment this.
        return
    elseif !empty(getloclist(0))
        lclose
        call setloclist(0, [], 'f')
    endif

    " Update the buffer.
    execute '1,' . string(line('$')) . 'delete'
    call setline(1, l:lines)

    " Restore cursor position and window state.
    call winrestview(l:cur_win)
endfunction

augroup Autoformat
    autocmd BufWritePre *.h,*.hh,*.hpp,*.c,*.cc,*.cu,*.cpp :call FormatBuffer('clang-format')
    autocmd BufWritePre *.py :call FormatBufferPy()
    " autocmd BufWritePre *.rs :call FormatBuffer('rustfmt --edition 2021')
    autocmd BufWritePre *.vert,*.frag :call FormatBuffer('clang-format')
    " autocmd BufWritePre *.go :GoFmt

    au FileType c,cpp setlocal formatprg=clang-format
    au FileType json setlocal formatprg=jq\ .
    " au FileType rust setlocal formatprg=rustfmt
augroup END

" Set up language specific options.

augroup ANTLR
    au BufRead,BufNewFile *.g set filetype=antlr4
    au BufRead,BufNewFile *.g4 set filetype=antlr4
augroup END

augroup Common
    " Fix YAML indentation and filetype detection for RAML
    au FileType yaml,html,vue,xml setlocal ts=2 sts=2 sw=2 expandtab

    " Setup JavaScrupt indentation
    au FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
augroup END

augroup Jinja
    au BufRead,BufNewFile *.j2 set filetype=jinja
augroup END

function! LintPython()
    cexpr system('ruff check -q --output-format=concise ' . expand('%'))
    cwindow
endfunction

function! Sync()
    system('make sync')
endfunction

augroup Python
    au FileType python setlocal errorformat^=%*[^:]:\ %f:%l:%c:\ %m
    au FileType python setlocal shellpipe=&>
    au FileType python setlocal makeprg=yapf\ -i\ %
    command Fmt :silent :make!

    au FileType python nmap gf :Fmt<cr>
    au FileType python nmap gl :call LintPython()<cr>
    au FileType python nmap gs :call Sync()<cr>
augroup END

augroup YAML
    au BufRead,BufNewFile *.yml,*.raml set filetype=yaml
    au BufRead,BufNewFile .clang-format set syntax=yaml
augroup END

augroup LaTeX
    au BufRead,BufNewFile *.tex setlocal filetype=tex wrap
augroup END

augroup Rust
    au FileType rust set signcolumn=yes
augroup END

augroup Typst
    au BufRead,BufNewFile *.typ setlocal filetype=typst
augroup END

let g:terraform_align=0
let g:terraform_fold_sections=0
let g:terraform_fmt_on_save=1

augroup Terraform
    au!
    au BufRead,BufNewFile *.tf set filetype=terraform
augroup END

augroup Tex
    nmap <C-Down> gj
    nmap <C-Up> gk
augroup END

" augroup Haskell
"     au BufWritePre *.hs lua vim.lsp.buf.formatting_sync()
" augroup END

augroup Typst
    au FileType typst nmap gl :make<cr><cr>:copen<cr>
    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
augroup END

" XXX Uncomment these lines to test lsp-lm
"
"augroup TXT
"    set completefunc=LanguageClient#complete
"
"    au BufRead,BufNewFile *.txt set filetype=txt
"    au BufRead,BufNewFile *.txt set wrap
"augroup END

" let g:LanguageClient_windowLogMessageLevel = 'Log'
" let g:LanguageClient_loggingFile = expand('~/.cache/LanguageClient.log')
" let g:LanguageClient_loggingLevel = 'INFO'
" let g:LanguageClient_diagnosticsEnable = 0
" let g:LanguageClient_serverCommands = {
"     \ 'c': ['clangd'],
"     \ 'cpp': ['clangd', '--background-index', '--compile-commands-dir', 'build'],
"     \ 'cuda': ['clangd', '--background-index', '--compile-commands-dir', 'build'],
"     \ 'go': ['gopls', 'serve'],
"     \ 'haskell': ['haskell-language-server-wrapper', 'lsp'],
"     \ 'rust': ['rust-analyzer'],
"     \ 'terraform': ['terraform-ls', 'serve'],
"     \ 'txt': ['tcp://127.0.0.1:5272'],
"     \ 'typst': ['typst-lsp'],
"     \ }

" Set up ack for comprehensive search in a workspace
let g:ackprg = 'ag -s --vimgrep'
nnoremap g/ :Ack<Space>
