call plug#begin()
Plug 'scwood/vim-hybrid'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'jwalton512/vim-blade'
Plug 'StanAngeloff/php.vim'
Plug 'Yggdroot/indentLine'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/bash-support.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'roosta/srcery'
Plug 'editorconfig/editorconfig-vim'
Plug 'dracula/vim'
Plug 'rking/ag.vim'
Plug 'skwp/greplace.vim'
Plug 'tpope/vim-surround'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'sebdah/vim-delve'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'zivyangll/git-blame.vim'
Plug 'easymotion/vim-easymotion'
Plug 'rust-lang/rust.vim'
Plug 'mhartington/formatter.nvim'
Plug 'hat0uma/csvview.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'
Plug 'leoluz/nvim-dap-go'
Plug 'github/copilot.vim'
call plug#end()

" Lua config
lua require('dap-go').setup()
lua require("mason").setup()
lua require("mason-lspconfig").setup()
lua require('csvview').setup()
lua require'lspconfig'.intelephense.setup{}
lua require('config')

"set t_Co=256
"set background=dark

" My Setting
set linespace=20
set nowrap
set tabstop=4
set softtabstop=4
set expandtab
set noswapfile
set autoindent
set shiftwidth=4
set autowrite
set showcmd
set mouse=a
set noshowmode
set complete=.,w,b,u
set backspace=indent,eol,start " backspace over everything in insert mode
set relativenumber
set wildmenu
set cc=120
set splitbelow
set splitright
set clipboard=unnamed

colorscheme tokyonight-night

let mapleader = ","
let g:mapleader = ","

nmap <leader>w :w!<cr>
nmap <leader>q :q<cr>

imap jj <esc>

" remap key
nnoremap <Leader>z :bp<CR>
nnoremap <Leader>c :bn<CR>
nnoremap <Leader>x :bd<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Setting NerdTree
map <C-e> :NERDTreeToggle<CR>
autocmd vimenter * NERDTree


" Setting Ctrl+P
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
map <Leader>p :CtrlPBuffer<CR>
map <C-r> :CtrlPBufTag<CR>

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,node_modules

" Setting Greplace
set grepprg=ag

let g:grep_cmd_opts = '--line-numbers --noheading'

" COC
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Give more space for displaying messages.
set cmdheight=2

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" " <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Golang
let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['govet', 'errcheck', 'go']

" Go Debug
" nnoremap <Leader>s :DlvDebug<CR>
" nnoremap <Leader>d :DlvToggleBreakpoint<CR>
" nnoremap <Leader>f :DlvToggleTracepoint<CR>
"
nnoremap <Leader>f :lua require('dap').continue()<CR>
nnoremap <F10> :lua require('dap').step_over()<CR>
nnoremap <F11> :lua require('dap').step_into()<CR>
nnoremap <F12> :lua require('dap').step_out()<CR>
nnoremap <Leader>d :lua require('dap').toggle_breakpoint()<CR>
" nnoremap <Leader>Q', function() dap.set_breakpoint() end)
" nnoremap <Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
" nnoremap <Leader>dr', function() dap.repl.open() end)
" nnoremap <Leader>dl', function() dap.run_last() end)
nnoremap <Leader>s :lua require('dapui').open()<CR>
nnoremap <Leader>S :lua require('dapui').close()<CR>

" Easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
