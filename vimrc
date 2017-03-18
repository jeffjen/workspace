" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Setup Pathogen to manage your plugins
" mkdir -p ~/.vim/autoload ~/.vim/bundle
" curl -so ~/.vim/autoload/pathogen.vim https://github.com/tpope/vim-pathogen.git
" Now you can install vim plugin into ~/.vim/bundle/<plugin-name>
call pathogen#infect()

" Rebind <Leader> key
let mapleader = ","

" Better copy & paste
set pastetoggle=<F2>
set clipboard=unnamedplus

" Quick copy to clipboard
nnoremap <Leader>y "*y

" Mouse and Backspace
" set mouse=a
set bs=2

"" Bind nohl
"" Remove highlight of your last search
"noremap <C-n> :nohl<CR>
"vnoremap <C-n> :nohl<CR>
"inoremap <C-n> :nohl<CR>

" Quick save command
noremap <C-x> :update<CR>
vnoremap <C-x> <C-C>:update<CR>
inoremap <C-x> <C-C>:update<CR>

" Quick new tab
noremap <C-s> :tabe<CR>
vnoremap <C-s> <C-C>:tabe<CR>

" Quick toggle paste mode
noremap <C-y> <esc>:set paste!<CR>
vnoremap <C-y> <esc>:set paste!<CR>

" Quick quit command
noremap <Leader>e :quit<CR>
noremap <Leader>E :qa<CR>
noremap <Leader>k :q!<CR>
noremap <Leader>K :qa!<CR>
noremap <Leader>t :tabnew<CR>

" bind Ctrl+<movement> keys to move around the windows,
" instead of using Ctrl+w + <movement>
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-h> <C-w>h

" Easier moving between tabs
map <Leader>m <esc>:tabprevious<CR>
map <Leader>n <esc>:tabnext<CR>

" Map sort function to a key
vnoremap <Leader>s :sort<CR>

" Easier moving of code blocks
vnoremap < <gv " better forward indentation
vnoremap > >gv " better backward indentation

" toogle buffer switching
nnoremap <PageUp>   :bp<CR>
nnoremap <PageDown> :bn<CR>

" change page scrolling key mapping
nnoremap J <c-f>zz
nnoremap K <c-b>zz

" Enable syntax highlighting
" You need to reload this file for change to apply
filetype off
filetype plugin indent on
syntax on
match Error /\s\+$/

" Showing line numbers and length
set number 	" show line numbers
set tw=79 	" width of document (used by gd)
set nowrap 	" don't automatically wrap on load
set fo-=t 	" don't automatically wrap text when typing
if version >= 703
    set colorcolumn=80
    highlight ColorColumn ctermbg=100
endif

" toggle line number on/off
map <F8> :set invnumber<CR>
map <F7> :set invwrap<CR>

" Useful settings
set history=700
set undolevels=700

" Real programmers use space, not TABs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Make search case insensitve
set hlsearch
set incsearch
set ignorecase
set smartcase

" Make swiching bufferes better
" Open in used tab if already opened, or open in new tab
set switchbuf+=usetab,newtab

"" Colo scheme
"" mkdir -p ~/.vim/colors && cd ~/.vim/colors
set t_Co=256
"set background=dark
colorscheme wombat256mod

""" Disable backup and swap files
""set nobackup
""set nowritebackup
""set noswapfile

" Settings for powerline
" git clone git://github.com/Lokaltog/vim-powerline.git [deprecated]
" see [https://powerline.readthedocs.org/en/latest/index.html]
set laststatus=2 " Always show the statusline in all window
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif

" Settings for ctrlp
" git clone git://github.com/kien/ctrlp.vim.git
let g:ctrlp_map = '<c-o>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 100
let g:ctrlp_max_height = 10
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](bower_components|node_modules|Godeps|\.venv|venv|\.git|\.hg|\.svn)$',
  \ 'file': '\v\.(pyc|class|o|sw*|iml|properties)$',
  \ }
let g:ctrlp_root_markers = ['.ctrlp']
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"" Settings for python-mode
"" git clone https://github.com/klen/python-mode
"map <Leader>g :call RopeGotoDefinition()<CR>
"let ropevim_enable_shortcuts = 1
"let g:pymode_rope_goto_def_newwin = 'vnew'
"let g:pymode_rope_extended_complete = 1
"let g:pymode_breakpoint = 0
"let g:pymode_syntax = 1
"let g:pymode_syntax_builtin_objs = 0
"let g:pymode_syntax_builtin_funcs = 0
"map <Leader>b 0import ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

" Better navigating through omnicomplete option list
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-n>"
        elseif a:action =='k'
            return "\<C-p>"
        endif
    endif
    return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

"" Python folding
"" mkdir -p ~/.vim/ftplugin
"set nofoldenable

au BufRead,BufNewFile bash-fc-* set filetype=sh
au BufRead,BufNewFile *.wsgi set filetype=python
au BufRead,BufNewFile *.thrift set filetype=cpp
au BufNewFile,BufReadPost *.md set filetype=markdown
au BufNewFile,BufReadPost *.mustache set filetype=html
