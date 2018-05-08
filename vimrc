 
 "--------------------------------------------------------------------------
" 
"           Key Mapping
"
"__________________________________________________________________________
 
:let mapleader = "," 
"set the leader key

nmap <Enter> i <Enter> <Esc>             
" nmap <BS> x
" inoremap <Space>i<Space><Esc>
"Map Q to formate paragraph.
 nnoremap Q gq}
"

"map j to format/validate json files.
nmap =j :%!python -m json.tool<CR>

"map x for formate xml
nnoremap <leader>x :%!xmllint --format - <CR>


nmap <Enter> i <Enter> <Esc>             
"    nmap <BS> x
"   inoremap <Space>i<Space><Esc>

nnoremap <leader>p "_diw"0P

" Create abbrivations for commonly mistyped 
" words
 iabbr viod void
 iabbr func function

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L> 

" increase decrease current splist window size.
map + <C-W>+
map - <C-W>-

" delete all the buffers except open one
" closed buffers.
" w | %bd | e#

" preview markdown files
nnoremap <leader>p :w<cr>:!pandoc % \| lynx -stdin<cr>:redraw!<cr>

"move the lines of code up/down with n and m. 
nmap <leader>n :m +1<CR>
nmap <leader>m :m -2<CR>
"--------------------------------------------------------------------------
"           
"           functions 
"__________________________________________________________________________

" goto next, previous fold
nnoremap <silent> <leader>zj :call NextClosedFold('j')<cr>
nnoremap <silent> <leader>zk :call NextClosedFold('k')<cr>
function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction

" Setup Omni complete on tab key
function! SuperCleverTab()
    if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
        return "\<Tab>"
    else
        if &omnifunc != ''
            return "\<C-X>\<C-O>"
        elseif
            &dictionary
            != ''
            return
            "\<C-K>"
        else
            return
            "\<C-N>"
        endif
    endif

 endfunction

inoremap <Tab> <C-R>=SuperCleverTab()<cr>
" See the diff of file on disk and current edited version
" can be used to see swap saved on disk :)
function! s:DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()
 
 
 
"--------------------------------------------------------------------------
"           
"            VIM Configurations 
"__________________________________________________________________________

" always open vertical split on the right.
set splitright 
 
 "enable mouse in all modes.
set mouse=a


set smartindent
set visualbell
set t_vb=
autocmd! GUIEnter * set vb t_vb=

if v:version >= 703
    "undo settings
    set undodir=~/.vim/undofiles
    set undofile
    "set colorcolumn=+1 "mark the ideal max text width
endif
 
 "default indent settings
set shiftwidth=4 
set softtabstop=8   " number of visual spaces per TAB
set tabstop=4       " number of spaces per TAB
set expandtab
if exists('+colorcolumn')
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

set autoindent
set showcmd         " show the command being types
set incsearch       " enable instant search

 "folding settings
set foldmethod=syntax               "fold based on indent
set foldnestmax=3                   "deepest fold is 3 levels
set nofoldenable                    "dont fold by default

set wildmode=list:longest           " make cmdline tab completion similar to bash

" configure 'find' command for vim.
"              ignore certain files when 'find' ing in vim
"              eg. find package.json (:find package.json)

set wildmenu                        " enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~         " ignore dynamically generated files.
set wildignore+=**/node_modules/**  " ignore node_module in node porjects
set wildignore+=*.swp,*.bak         " ignore vim swap and backup files.
set wildignore+=*/.git/**/*         " ignore .git and its contents
set wildignore+=*/.svn/**/*         " ignore .svn and its contents.
set wildignore+=tags,cscope.*       " ignore tags
set wildignore+=*.tar.*             " ignore tar files.
"set wildignore+=*.pyc,*.class,*.sln,*.Master,*.csproj,*.csproj.user,*.cache,*.dll,*.pdb,*.min.*

set nowrapscan                      "do not wrap around search 
set formatoptions-=o                "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1
 

set number                          "show line numbers
set relativenumber                  " current line number is relative

set ignorecase
:set wildignorecase
set smartcase 

" set vim path dynamically to current working directory
" remember this does not work if you change vim directory from within vim.
set path+=**
"change search highlight color
:highlight IncSearch gui=underline,bold guifg=White guibg=Red3
 
set backspace=indent,eol,start  
 
set nostartofline

"setup temp file directory.
set directory=~/.vim/swapfiles/

" I like to see my cursor position like :)
set cursorline
set cursorcolumn

" Ignore white space while taking diff 
if &diff
set diffopt+=iwhite
endif

autocmd BufRead,BufNewFile *.md setlocal spell
"--------------------------------------------------------------------------
" 
"          Plugins 
"
"__________________________________________________________________________


" Add pathogen to load autoload pugins
set nocp
execute pathogen#infect()
filetype plugin indent on
syntax on
set omnifunc=syntaxcomplete#Complete        "enbale onmicomplete for smart autocompletion.

"User tern based javascript autocompletion
"tern#true

" Set airline statusline to appear even in single vim editor
" https://github.com/vim-airline/vim-airline.git
set laststatus=2
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" the separator used on the left side >
let g:airline_left_sep='>'
" the separator used on the right side >
let g:airline_right_sep='<'
" enable modified detection >
let g:airline_detect_modified=1
" enable paste detection >
let g:airline_detect_paste=1
" enable/disable syntastic integration >
let g:airline#extensions#syntastic#enabled = 1
"let g:statusline:%{fugitive#statusline()}


"vim-jsx
"https://github.com/mxw/vim-jsx.git
"Syntax highlighting and indenting for JSX. JSX is a JavaScript syntax
"transformer which translates inline XML document fragments into JavaScript
"objects. It was developed by Facebook alongside React.
let g:jsx_ext_required = 0

"configure emment to use tab completion
"let g:user_emmet_leader_key='<Tab>'
let g:user_emmet_settings = {
  \  'javascript.js' : {
    \      'extends' : 'js',
    \  },
  \}
" vim javascript
" JavaScript bundle for vim, this bundle provides syntax highlighting and improved indentation.
"https://github.com/pangloss/vim-javascript.git
"let g:javascript_plugin_jsdoc = 1
"let g:javascript_plugin_ngdoc = 1

"Concealing Characters
let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "⇚"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_NaN                  = "ℕ"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"
let g:javascript_conceal_noarg_arrow_function = "🞅"
let g:javascript_conceal_underscore_arrow_function = "🞅"

" set concealing in vim
set conceallevel=1

" toggle concealing
map <leader>l :exec &conceallevel ? "set conceallevel=0" : "set conceallevel=1"<CR>


if version < 800
    set runtimepath-=~/.vim/bundle/ale
    let g:ale_sign_error = '●' " Less aggressive than the default '>>'
    let g:ale_sign_warning = '.'
    let g:ale_lint_on_enter = 0 " Less distracting when opening a new file
endif
" async linting
" https://github.com/w0rp/ale
"Use ale plugin
" use specific linter for specific file type.
let g:ale_linters = {
            \   'javascript': ['eslint'],
            \}
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

"      ag
" the silver searcher for vim set to be used with vimgrep
let g:ackprg = 'ag --vimgrep'
"let g:ackprg = 'ag --nogroup --nocolor --column'

"--------------------------------------------------------------------------
" 
"          Color schemes / themes
"__________________________________________________________________________

" see if vim is running in gui
"if has('gui_running')

set t_Co=256
syntax enable
"let g:solarized_termtrans = 1                                                   
let g:solarized_termcolors=256                                                  
"set background=light  
set background=dark
colorscheme solarized

"set guifont=Menlo:h12

"downgrade colours to use solarized dar colorscheme. Does not look as good as I like.

":set t_Co=16

"   Tagbar is a Vim plugin that provides an easy way to browse the tags of the current file and get an overview of its structure. 
"   https://github.com/majutsushi/tagbar.git
nmap <F8> :TagbarToggle<CR>

"--------------------------------------------------------------------------
"                          Tutorial section
"--------------------------------------------------------------------------

" Help
" 1. "shift + k" => show help page for keyword under the cursor
" 2. ":help help" => show help about getting help


" Enable spell checker.
"set spell spelllang=en_us
"set nospell
" goto next misspell "]s"
" goto previous misspell "[s"
" once on a misspell "z=" to get suggestions.
" autocmd BufRead,BufNewFile *.md setlocal spell " enable spell check for md
" files.

"--------------------------------------------------------------------------
"                          Code folding
"--------------------------------------------------------------------------
" 1. make sure foldmethod(fdm) is set properly.
" 2. open folds:      za, zC, zc 
" 3. close folds:     zo, zO
" 4. goto next fold:  
" 5. previous fold: 
"--------------------------------------------------------------------------
" 
"          auto commands
"
"__________________________________________________________________________

"
" auto reload vim, when there are changes in .vimrc
"
"augroup myvimrc
"   au!
"   au BufWritePost .vimrc so $MYVIMRC 
"augroup END

"                    Info 
"   commmands that I wish  to remember, but do not wish to add here.
"__________________________________________________________________________
"   Read Only buffers
"   set ro      " make a buffer read only,
"   set noro    " make a buffer editable,
"   set nospell 
"       
"       make session
"       :mks ept.vim
""--------------------------------------------------------------------------
" 
"          VIM DIFF  
"           Tutorial
"__________________________________________________________________________
" Start in diff mode 
" vimdiff file1 file2 [file3 [file4]]
"vim -d file1 file2 [file3 [file4]]


"Vertical diff 
"vimdiff -o file1 file2 [file3 [file4]]

"take diff white in normal mode
" 1. diffthis
" 2. diffsplit
" 3. diffpatch

" Switch mode
" :diffoff
" :diffoff!

"   Update diff
" :diffupdate

"  next change               ]c
"  previous change           [c 
"  diff obtain              do
"  diff put                 dp
"__________________________________________________________________________

" Start in diff mode 
" vimdiff file1 file2 [file3 [file4]]
"vim -d file1 file2 [file3 [file4]]


"Vertical diff 
"vimdiff -o file1 file2 [file3 [file4]]

"take diff white in normal mode
" 1. diffthis
" 2. diffsplit
" 3. diffpatch

" Switch mode
" :diffoff
" :diffoff!

"   Update diff
" :diffupdate
"
"  next change               ]c
"  previous change           [c 
"  diff obtain              do
"  diff put                 dp

"__________________________________________________________________________
"
"           List of VIM lists
"__________________________________________________________________________

"1.    Jump list
"       Jumps taken with movement commands.
"   show            ju[mps]
"   next            <C-o>
"   previous        <C-i>

"2.    Change list
"       Each undoable change made in buffer.
"   show            :changes
"   old             g;
"   new             g,

"3.    Quickfix list
"       A list of locations across the files.
"   open            :cope[n]
"   close           :ccl[ose]
"   next            :cn[ext]         / ]q
"   previous        :cp[revious]     / [q 
"   first           :cfir[st]        / ]Q
"   last            :cla[st]         / [Q

"4.    Location list
"        A window local quickfix list
"   open            :lope[n]         
"   close           :lcl[ose]
"   next            :lne[xt]         / ]l       
"   previous        :lp[revious]     / [l       
"   first           :lfir[st]        / ]L
"   last            :lla[st]         / [L

"5.    Buffer list
"       Files open in vim
"   open            :buffers         / ls
"   next            :bn[ext]         / ]b
"   previous        :bp[revious]     / [b       
"   first           :bf[irst]        / ]B
"   last            :bl[last]        / [B

"5.    Argument list
"       List of arguments passed to vim
"   open            :ar[gs]
"   next            :n[ext]          / ]a
"   previous        :prev[ious]      / [a       
"   first           :fir[irst]       / ]A
"   last            :la[st]          / [A

"6.    Tag stack
"       Tag jumps
"   Show            :tags
"   Previous        :po[p] / <C-t>
"   Next            :ta[g]

"7.    Tag match list
"       When there are multiple matches for a tag.
"   Show            :ts[elect]
"   Previous        :tp[revious]     / [t*
"   Next            :tn[ext]         / ]t*
"   First           :tf[irst]        / [T*
"   Last            :tl[ast]         / ]T*

