set nocompatible
set background=dark
set number

set scrolloff=2
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent
set mouse=a

" Prefer to use Python 3.
let g:python_host_prog = '/usr/bin/python3'
let g:python3_host_prog = '/usr/bin/python3'

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

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

noremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

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
set wildignore+=*/tmp/*,*.so,*.swp,*.pyc,.env/*,*.egg-info/*,*/env/*,*/node_modules/*,*/__pycache__/*

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](\.(git|hg|svn|egg-info|dvc|env)|build)$',
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
        "lopen 1
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

augroup Atutoformat
    autocmd BufWritePre *.h,*.hh,*.hpp,*.c,*.cc,*.cpp :call FormatBuffer('clang-format')
    autocmd BufWritePre *.py :call FormatBufferPy()
    autocmd BufWritePre *.rs :call FormatBuffer('rustfmt')
    autocmd BufWritePre *.vert,*.frag :call FormatBuffer('clang-format')

    au FileType c,cpp setlocal formatprg=clang-format
    au FileType json setlocal formatprg=jq\ .
    au FileType rust setlocal formatprg=rustfmt
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

augroup CXX
    func! Goto_declaration_new_tab()
        let pos = ncm2_pyclang#find_declaration()
        if empty(pos)
            return
        endif
        let filepath = expand("%:p")
        if filepath != pos.file
            let fes = fnameescape(pos.file)
            exe 'tabnew' fes
        else
            normal! m'
        endif
        call cursor(pos.lnum, pos.bcol)
    endfunc

    au!
    au FileType c,cpp nnoremap <buffer> gd :<c-u>call Goto_declaration_new_tab()<cr>
augroup END

augroup Jinja
    au BufRead,BufNewFile *.j2 set filetype=jinja
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

let g:terraform_align=0
let g:terraform_fold_sections=0
let g:terraform_fmt_on_save=1

augroup Terraform
    au!
    au BufRead,BufNewFile *.tf set filetype=terraform
augroup END

let g:LanguageClient_windowLogMessageLevel = 'Log'
let g:LanguageClient_loggingFile = expand('~/LanguageClient.log')
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_serverCommands = {
    \ 'txt': ['tcp://127.0.0.1:5272'],
    \ 'rust': ['rls'],
    \ 'terraform': ['terraform-ls', 'serve', '-log-file', '/tmp/lsp-terraform.log'],
    \ }

" Set up ack for comprehensive search in a workspace
let g:ackprg = 'ag -s --vimgrep'
nnoremap g/ :Ack<Space>
