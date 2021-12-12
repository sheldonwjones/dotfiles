scriptencoding utf-8 " use utf-8 encoding
set nocompatible     " disable compatibility with old vi
"set shell=/usr/bin/zsh

"let g:python_host_prog = $PYTHON_HOST_PROG
"let g:python3_host_prog = $PYTHON3_HOST_PROG
" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "
" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.config/nvim/plugged')

" colorscheme
Plug 'sainnhe/edge'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


" tmux
Plug 'urbainvaes/vim-tmux-pilot'
Plug 'edkolev/tmuxline.vim'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'

" misc
Plug 'liuchengxu/vista.vim'
Plug 'preservim/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'ntpeters/vim-better-whitespace'
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'farmergreg/vim-lastplace'

" javascript and typescript
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
"Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'

"languages
Plug 'sheerun/vim-polyglot'
"Plug 'pearofducks/ansible-vim', { 'do': './UltiSnips/generate.sh' }
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins', 'for' :['python', 'vim-plug'] }
Plug 'psf/black', {
  \ 'for': ['python'] }
Plug 'tmhedberg/SimpylFold', {
  \ 'for': ['python'] }
Plug 'dense-analysis/ale', {
  \ 'do': 'pip install --upgrade flake8 pylint autopep8 black' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Initialize plugin system
call plug#end()


" ============================================================================ "
" ===                              SETTINGS                                === "
" ============================================================================ "
let g:mapleader=','         " Remap leader key to ,

set showmatch               " Show matching brackets
set scrolloff=5             " Keep 5 lines on the screen when scrolling
set shortmess+=c            " Don't give completion messages like 'match 1 of 2'
set shortmess+=F            " Don't give file save messages
set laststatus=2            " Alaways show a status line
set number                  " Enable line numbers
set noshowcmd               " Don't show last command
set autoread                " Re-read file if a change was detected outside of vim
set mouse=r                 " Middle-click paste with mouse

set hlsearch                " Highlight search results
set ignorecase              " Case insensitive matching
set smartcase               " If mixed case search, the search will be case sensitive
set expandtab               " Insert spaces when TAB is pressed.
set tabstop=2               " Number of columns occupied by a tab character
set softtabstop=2           " See multiple spaces as tabstops so <BS> does the right thing
set shiftwidth=2            " Width for autoindents
set autoindent              " Indent a new line the same amount as the line just typed
set number                  " Add line numbers
set hidden                  " Hides buffers instead of closing them
set nowrap                  " Do not wrap long lines by default
set cursorline              " Highlight current cursor line
set cursorcolumn             " Highlight current cursor column
set noruler                 " Disable line/column number in status line (airline has this)

set wildmode=longest,list   " Get bash-like tab completions
"set cc=80                   " Set an 80 column border for good coding style
"set cmdheight=2             " Only one line for command line
filetype plugin indent on   " Allows auto-indenting depending on file type
syntax on                   " Syntax highlighting

" Set backups
if has('persistent_undo')
  set undofile
  set undolevels=3000
  set undoreload=10000
endif
set backupdir=~/.local/share/nvim/backup " Don't put backups in current dir
set backup
set noswapfile

autocmd BufNewFile,BufRead *.py
      \ set tabstop=4      |
      \ set softtabstop=4  |
      \ set shiftwidth=4

"set clipboard=unnamed       " Yank and paste with the system clipboard


" ============================================================================ "
" ===                                 UI                                   === "
" ============================================================================ "
" important!!
set termguicolors

" for dark version
set background=dark

let g:edge_transparent_background = 1

colorscheme edge

" use the terminals background color and opacity settings
hi NonText ctermbg=NONE
hi Normal guibg=NONE ctermbg=NONE

let g:airline_theme = 'edge'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1


" ============================================================================ "
" ===                            KEY MAPPINGS                              === "
" ============================================================================ "

" NOTE: FZF is using settings from my zsh env to make preview work

" jazz up ripgrep with preview
command! -bang -nargs=* Rg
  \ call fzf#vim#grep('rg -E "*.png" --column --no-heading --line-number --color=always '.shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview(),
  \ <bang>0)

" jazz up fzf with preview.
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>,
  \ fzf#vim#with_preview(),
  \ <bang>0)

" fzf git commits
let g:fzf_commits_log_options = '--graph --color=always
  \ --format="%C(yellow)%h%C(red)%d%C(reset)
  \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

" folds
nnoremap <space> za

" fzf
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>d :Files <C-r>=expand("%:p:h")<CR>/<CR>
"nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>m :FZFMru<CR>
nnoremap <silent> <Leader>]  :Tags<CR>
nnoremap <silent> <Leader>b] :BTags<CR>
nnoremap <silent> <Leader>c  :Commits<CR>
nnoremap <silent> <Leader>bc :BCommits<CR>

" buffers
nmap <BS> :Buffers<CR>
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

" ripgrep
nnoremap <Leader>rg :Rg<CR>
nnoremap <Leader>!  :Rg!<CR>

" easymotion search
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)


" ============================================================================ "
" ===                                TMUX                                  === "
" ============================================================================ "

" mirror the setting in my .tmux.conf file
let g:pilot_mode='winonly'
let g:pilot_boundary='create'

" my tmux status line
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'c'    : ['#(whoami)', '#(uptime | cut -d " " -f 1,2,3)'],
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W', '#F'],
      \'x'    : '#(date)',
      \'y'    : ['%R', '%a'],
      \'z'    : '#H'}
let g:tmuxline_separators = {
      \ 'left' : "\ue0b4",
      \ 'left_alt': "\ue0b5",
      \ 'right' : "\ue0b6",
      \ 'right_alt' : "\ue0b7",
      \ 'space' : ' '}


" ============================================================================ "
" ===                                MISC                                  === "
" ============================================================================ "
let g:indentLine_char_list = ['|', '¦', '┆', '┊']


let g:ale_linters = {
      \   'python': ['flake8'],
      \   'javascript': ['eslint', 'prettier'],
      \   'css': ['prettier'],
      \   'sh': ['shellcheck'],
      \}

"      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
let g:ale_fixers = {
      \   'javascript': ['eslint'],
      \   'python': ['black', 'autopep8'],
      \}

let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1

" auto resize splits
autocmd VimResized * wincmd =


" ============================================================================ "
" ===                                 COC                                  === "
" ============================================================================ "
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-prettier',
  \ 'coc-eslint'
  \ ]

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
