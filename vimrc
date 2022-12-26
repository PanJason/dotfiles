set nocompatible " not vi compatible
" Define VB mode shortcut
command! VB normal! <C-v>
"------------------
" Syntax and indent
"------------------
syntax on " turn on syntax highlighting
set showmatch " show matching braces when text indicator is over them

" highlight current line, but only in active window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

" vim can autodetect this based on $TERM (e.g. 'xterm-256color')
" but it can be set to force 256 colors
" set t_Co=256
if has('gui_running')
    colorscheme desert
    let g:lightline = {'colorscheme': 'desert'}
elseif &t_Co < 256
    colorscheme default
    set nocursorline " looks bad in this mode
else
    set background=dark
    let g:solarized_termcolors=256 " instead of 16 color with mapping in terminal
    colorscheme desert
    " customized colors
    highlight SignColumn ctermbg=234
    highlight StatusLine cterm=bold ctermfg=245 ctermbg=235
    highlight StatusLineNC cterm=bold ctermfg=245 ctermbg=235
    let g:lightline = {'colorscheme': 'dark'}
    highlight SpellBad cterm=underline
    " patches
    highlight CursorLineNr cterm=NONE
endif

filetype plugin indent on " enable file type detection
set autoindent

"---------------------
" Basic editing config
"---------------------
set nu " number lines
set rnu " relative line numbering
set incsearch " incremental search (as string is being typed)
set hls " highlight search
set listchars=tab:>>,nbsp:~ " set list to see tabs and non-breakable spaces
set lbr " line break
set scrolloff=5 " show lines above and below cursor (when possible)
set laststatus=2
set backspace=indent,eol,start " allow backspacing over everything
set timeout timeoutlen=1000 ttimeoutlen=100 " fix slow O inserts
set lazyredraw " skip redrawing screen in some cases
"set hidden " allow auto-hiding of edited buffers
set history=8192 " more history
set nojoinspaces " suppress inserting two spaces between sentences
" use 4 spaces instead of tabs during formatting
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
" smart case-sensitive search
set ignorecase
set smartcase
" tab completion for files/bufferss
set wildmode=longest,list
set wildmenu
set mouse+=a " enable mouse mode (scrolling, selection, etc)
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif
set nofoldenable " disable folding by default
set showcmd

"--------------------
" Misc configurations
"--------------------

" open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" movement relative to display lines
nnoremap <silent> <Leader>d :call ToggleMovementByDisplayLines()<CR>
function SetMovementByDisplayLines()
    noremap <buffer> <silent> <expr> k v:count ? 'k' : 'gk'
    noremap <buffer> <silent> <expr> j v:count ? 'j' : 'gj'
    noremap <buffer> <silent> 0 g0
    noremap <buffer> <silent> $ g$
endfunction
function ToggleMovementByDisplayLines()
    if !exists('b:movement_by_display_lines')
        let b:movement_by_display_lines = 0
    endif
    if b:movement_by_display_lines
        let b:movement_by_display_lines = 0
        silent! nunmap <buffer> k
        silent! nunmap <buffer> j
        silent! nunmap <buffer> 0
        silent! nunmap <buffer> $
    else
        let b:movement_by_display_lines = 1
        call SetMovementByDisplayLines()
    endif
endfunction

" toggle relative numbering
nnoremap <C-n> :set rnu!<CR>

"---------------------
" Plugin configuration
"---------------------

let g:my_project_root = ['.svn', '.git', '.root', '_darcs', 'build.xml']

" Enable Plug in
call plug#begin()
" Argwrap
Plug 'FooSoft/vim-argwrap'
" Emmet for vim
Plug 'mattn/emmet-vim'
" A tree explorer plugin for vim
Plug 'preservim/nerdtree'
" lean & mean status/tabline for vim that's light as air
Plug 'vim-airline/vim-airline'
" Vim motions on speed!
Plug 'easymotion/vim-easymotion'
" Vim motions (with key s)
Plug 'justinmk/vim-sneak'
" quoting/parenthesizing made simple ysaW{
Plug 'tpope/vim-surround'
" cscope
Plug 'dr-kino/cscope-maps'
" Toggle comment
Plug 'chrisbra/vim-commentary'
" Text object  di,
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
Plug 'sgur/vim-textobj-parameter'
" Diff
Plug 'mhinz/vim-signify'
" Linting
Plug 'dense-analysis/ale'
" <leader>b / <leader>f: search buffer / files
" Also install the C extension of the fuzzy matching algorithm
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
" Auto generate ctags files
" https://ctags.io/
Plug 'ludovicchabant/vim-gutentags'
" AsyncRun
Plug 'skywind3000/asyncrun.vim'
" C++ Syntax highlighting
Plug 'octol/vim-cpp-enhanced-highlight'
" Rust
Plug 'rust-lang/rust.vim'
" YCM
Plug 'ycm-core/YouCompleteMe'
" tabular
Plug 'godlygeek/tabular'
" Markdown
Plug 'preservim/vim-markdown'
call plug#end()

" argwrap
nnoremap <Leader>aw :ArgWrap<CR>
noremap <Leader>oc :OverCommandLine<CR>

" nerdtree
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<CR>

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1

" easymotion
map <Space> <Plug>(easymotion-prefix)

" signify
highlight SignifySignAdd ctermfg=green
highlight SignifySignDelete ctermfg=red
highlight SignifySignChange ctermfg=yellow
nnoremap <Leader>di :SignifyDiff<CR>

" ale
"let g:ale_set_highlights = 0
"highlight ALEError ctermbg=none cterm=underline
highlight ALEError ctermbg=DarkRed
highlight ALEWarning ctermbg=DarkMagenta
"highlight ALEErrorSign ctermbg=DarkRed
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_c_build_dir_names = ['build', 'bin', 'cmake-build-debug']

" Leaderf
nnoremap <Leader>mru :LeaderfMru<CR>

" gutentags
let g:gutentags_project_root = g:my_project_root
let g:gutentags_ctags_tagfile = '.tags'
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" asyncrun
let g:asyncrun_open = 10  " window height
let g:asyncrun_bell = 1
" Compile single file
nnoremap <F9> :AsyncRun gcc -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
" Run
nnoremap <F5> :AsyncRun -raw -cwd=$(VIM_FILEDIR) "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
let g:asyncrun_rootmarks = g:my_project_root
" Make
nnoremap <Leader>cm :AsyncRun -cwd=<root> cmake -S . -B build<CR>
nnoremap <Leader>mk :AsyncRun -cwd=<root> cmake --build build<CR>
nnoremap <Leader>te :AsyncRun -cwd=<root> cmake --build build --target test<CR>
nnoremap <Leader>py :!python3 %<CR>

" C++ highlight
let g:cpp_member_variable_highlight = 1
let g:cpp_class_scope_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_class_decl_highlight = 1

" YCM
let g:ycm_filetype_whitelist = {
\ 'c': 1,
\ 'cc': 1,
\ 'cpp': 1,
\ 'h': 1,
\ 'rs': 1,
\ 'sh': 1,
\ 'go': 1,
\}
let g:ycm_show_diagnostics_ui = 0
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0
set completeopt=menu,menuone
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }

" incsearch
"nnoremap <Leader>/ <Plug>(incsearch-forward)<CR>
"nnoremap <Leader>? <Plug>(incsearch-backward)<CR>
"nnoremap <Leader>g/ <Plug>(incsearch-stay)<CR>


" markdown
let g:markdown_fenced_languages = [
    \ 'bash=sh',
    \ 'c',
    \ 'coffee',
    \ 'erb=eruby',
    \ 'javascript',
    \ 'json',
    \ 'perl',
    \ 'python',
    \ 'ruby',
    \ 'yaml',
    \ 'go',
    \ 'racket',
    \ 'haskell',
    \ 'rust',
\]
let g:markdown_syntax_conceal = 0
let g:markdown_folding = 1

"---------------------
" Local customizations
"---------------------

" local customizations in ~/.vimrc_local
let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif
