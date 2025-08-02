set nocompatible
set mouse-=a

syntax on
filetype on
filetype plugin on
filetype indent on

" Save cursor position
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

" Spell checking
autocmd FileType tex setlocal spell spelllang=en_us,ru

" Clipboard
set clipboard=unnamedstar  " see :help 'clipboard'

" Number of spaces that a <Tab> in the file counts for.  Also see
" |:retab| command, and 'softtabstop' option.
set tabstop=4

" Returns the effective value of 'shiftwidth'. This is the
" 'shiftwidth' value unless it is zero, in which case it is the
" 'tabstop' value.
set shiftwidth=4

" When on, a <Tab> in front of a line inserts blanks according to
" 'shiftwidth'.  'tabstop' or 'softtabstop' is used in other places.  A
" <BS> will delete a 'shiftwidth' worth of space at the start of the
" line.
" When off, a <Tab> always inserts blanks according to 'tabstop' or
" 'softtabstop'.  'shiftwidth' is only used for shifting text left or
" right |shift-left-right|.
" What gets inserted (a <Tab> or spaces) depends on the 'expandtab'
" option.  Also see |ins-expandtab|.  When 'expandtab' is not set, the
" number of spaces is minimized by using <Tab>s.
set smarttab

" In Insert mode: Use the appropriate number of spaces to insert a
" <Tab>.  Spaces are used in indents with the '>' and '<' commands and
" when 'autoindent' is on.  To insert a real tab when 'expandtab' is
" on, use CTRL-V<Tab>.  See also |:retab| and |ins-expandtab|.
set expandtab

" Do smart autoindenting when starting a new line.  Works for C-like
" programs, but can also be used for other languages.  'cindent' does
" something like this, works better in most cases, but is more strict,
" see |C-indenting|.  When 'cindent' is on or 'indentexpr' is set,
" setting 'si' has no effect.  'indentexpr' is a more advanced
" alternative.
set smartindent

" Fix YAML indentation and filetype detection for RAML
au FileType yaml,html,vue,xml setlocal ts=2 sts=2 sw=2 expandtab
au BufRead,BufNewFile *.raml set filetype=yaml

" Fix Cucumber indentation
au FileType cucumber setlocal ts=2 sts=2 sw=2 expandtab

" Spell checking for tex
au FileType tex set spelllang=en,ru

" Wrap long line for Tex, Markdown and text file
au BufRead,BufNewFile *.tex set ai si textwidth=79
au BufRead,BufNewFile *.txt set ai si textwidth=79
"au BufRead,BufNewFile *.md set ai si textwidth=79 formatoptions+=a

" Mail file format for Mutt
autocmd BufRead,BufNewFile *mutt-* setfiletype mail

" Line break
au FileType python set breakindentopt=shift:4

" Russian keyboard layout in commnad mode
"set langmap=!\\"№\\;%?*ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;!@#$%&*`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>

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

" Tagbar plugin intergration from gotags
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" Supertab plugin settings
let g:SuperTabNoCompleteAfter = ['^', '\s', '#', '//', '^--', ',', '\''', '{', '}', ':', ';', '!', '(', ')', '/', '`', '*', '-', ']']

" EasyTags settings
set tag=./.tags,../.tags,../../.tags

" Tabs mapping. It is require setting up your terminal emulator to map
" Control-Tab and Control-Shift-Tab to pseudo escape sequences keys
" correspondetly.
nmap <C-n> :tabnew<CR>
nmap [control~tab$ :tabn<CR>
nmap [control~shift~tab$ :tabp<CR>

" Vim Pad settings.
set runtimepath^=~/.vim/vim-pad
let g:pad#dir = "~/.notes/"

let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_server_python_interpreter = '/usr/bin/python2'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_show_diagnostics_ui = 0
let g:ycm_min_num_of_chars_for_completion = 3
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
