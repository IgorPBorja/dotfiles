" General Settings
set number              " Show line numbers
set nowrap              " Disable line wrapping
set tabstop=4           " Set tab size to 4 spaces
set softtabstop=4
set shiftwidth=4        " Set indentation level to 4 spaces
set expandtab           " Use spaces instead of tabs
set autoindent          " Enable auto-indentation
set smartindent         " Enable smart indentation
set mouse=a             " Enable mouse support
set autochdir           " Automatically set working directory to current file

let mapleader = "\<Space>"

" Plugin Management
call plug#begin('~/.vim/plugged')
    " Color theme onedark
    Plug 'joshdick/onedark.vim'

	" GitHub Copilot
	Plug 'github/copilot.vim'

	" Telescope
	Plug 'nvim-lua/popup.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'

	" Telescope File Browser
    Plug 'nvim-telescope/telescope-file-browser.nvim'

	" Plugin for debugger
	Plug 'puremourning/vimspector'

    " nvim-treesitter
    Plug 'nvim-treesitter/nvim-treesitter'

    " Bufferline
    Plug 'akinsho/bufferline.nvim'

    " Nerdcommenter
    Plug 'preservim/nerdcommenter'

    " nvim-autopairs
    Plug 'windwp/nvim-autopairs'

    " color TODOs
    Plug 'folke/todo-comments.nvim'

    " Lualine: useful information (mode, git branch, etc)
    " NOT USING FOR NOW (MAKES NEOVIM SLOW)
    " Plug 'nvim-lualine/lualine.nvim'
call plug#end()

" Keybindings
" GitHub Copilot Keybindings
lua << EOF
	vim.g.copilot_no_tab_map = true
    vim.g.copilot_accept_map = 'g<Tab>' -- Map Shift+Tab to accept Copilot suggestion
    vim.g.copilot_disable_map = '<Leader>gd'
    vim.g.copilot_undo_map = '<Leader>gu'
    vim.g.copilot_select_prev_map = '<Leader>gp'
    vim.g.copilot_select_next_map = '<Leader>gn'

	vim.api.nvim_set_keymap("i", "<S-Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
EOF

" C/C++ LSP
if executable('clangd')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '--background-index']},
        \ 'whitelist': ['c', 'cpp'],
        \ })
endif
" Python LSP
if executable('pyright')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyright',
        \ 'cmd': {server_info->['pyright-langserver', '--stdio']},
        \ 'whitelist': ['python'],
        \ })
endif

" Lua LSP
let g:lua_language_server_path = '~/lua-language-server/main.lua'
lua << EOF
local lua_language_server_path = vim.g.lua_language_server_path

if vim.fn.executable(lua_language_server_path) == 1 then
    local lsp = require('vim.lsp')
    lsp.start_client({
        cmd = {lua_language_server_path, "-E", "-e", "LANG=en", "--", vim.fn.stdpath('config').."/lua-language-server/main.lua"},
        ...
    })
end
EOF

" Vimscript LSP
if executable('vim-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'vim-language-server',
        \ 'cmd': {server_info->['vim-language-server']},
        \ 'whitelist': ['vim'],
        \ })
endif

" LSP Configuration
augroup my_lsp_cpp
  autocmd!
  autocmd FileType c,cpp lua require'lspconfig'.clangd.setup{}
augroup END

" Autocomplete Configuration for C++ files
autocmd FileType c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc

augroup my_lsp_cpp
  au!
  autocmd FileType c,cpp nnoremap <silent> <buffer> gd <cmd>lua vim.lsp.buf.definition()<CR>
  autocmd FileType c,cpp nnoremap <silent> <buffer> gD <cmd>lua vim.lsp.buf.declaration()<CR>
  autocmd FileType c,cpp nnoremap <silent> <buffer> gr <cmd>lua vim.lsp.buf.references()<CR>
  autocmd FileType c,cpp nnoremap <silent> <buffer> gi <cmd>lua vim.lsp.buf.implementation()<CR>
  autocmd FileType c,cpp nnoremap <silent> <buffer> K :lua vim.lsp.buf.hover()<CR>
  autocmd FileType c,cpp nnoremap <silent> <buffer> <F2> :lua vim.lsp.buf.rename()<CR>
augroup END

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>help <cmd>Telescope help_tags<cr>
nnoremap <leader>gs <cmd>Telescope git_status<cr>
nnoremap <leader>gc <cmd>Telescope git_commits<cr>
nnoremap <leader>tree <cmd>Telescope treesitter<cr>
" Telescope FZF integration for file browsing
nnoremap <leader>fo <cmd>Telescope file_browser<CR>

" Autocomplete Configuration
" Autocomplete Configuration
set completeopt=menuone,noinsert,noselect

augroup my_lsp_completion
    autocmd!
    autocmd InsertEnter * call s:activate_lsp()
    autocmd InsertLeave * call s:deactivate_lsp()
augroup END

function! s:activate_lsp()
    if &l:filetype =~ 'cpp'
        lua vim.lsp.buf.completion_active()
    endif
endfunction

function! s:deactivate_lsp()
    if &l:filetype =~ 'cpp'
        lua vim.lsp.buf.completion_inactive()
    endif
endfunction

" Map Tab to accept LSP autocomplete first suggestion
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"


"" Vimspector stuff

" ------------------------------------------------
"  Configuration for debugging with vimspector
"  vimspector is not a debugger, but a front-end/middle-man between vim and
"  the existing debuggers for various languages, like python (e.g.: debugpy), node
"  (e.g: vscode-node), etc
" ------------------------------------------------

nnoremap <Space>ds :call vimspector#Launch()<CR>
nnoremap <Space>dr :call vimspector#Reset()<CR>
nnoremap <Space>dc :call vimspector#Continue()<CR>
nnoremap <Space>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Space>dT :call vimspector#ClearBreakpoints()<CR>
nnoremap <Space>dk :call vimspector#Restart()<CR>
nnoremap <Space>dh :call vimspector#StepOut()<CR>
nnoremap <Space>dl :call vimspector#StepInto()<CR>
nnoremap <Space>dj :call vimspector#StepOver()<CR>

command! DebugMappings call s:ShowDebugMappings()
command! LspMappings call s:ShowLspMappings()

function! s:ShowFloat(lines) abort
	" Create new scratch buffer for the floating window
	" nvim_create_buf takes 2 arguments (boolean flags)
	" the first one (listed) determines if the buffer should be listed or not
	" (listed buffers are the ones that appear on the tab view at the top and on telescope buffer list (<Leader>b))
	" the other is "scratch" and I don't know exactly what it is for
	let bufnr = nvim_create_buf(v:false, v:false)

	call nvim_buf_set_lines(bufnr, 0, -1, v:true, a:lines)

	" Create a floating window and set its content
	let b:win_id = nvim_open_win(bufnr, v:true, {
		\ 'relative': 'win',
		\ 'row': 2,
		\ 'col': 2,
        \ 'width' : 100,
        \ 'height' : 25,
        \ 'style' : 'minimal'
        \ })

    " Set the window to close when pressing 'q'
	nnoremap <buffer><silent> q :call nvim_win_close(b:win_id, v:true)<CR>

    " Set the window to close when leaving insert mode
	inoremap <buffer><silent> <Esc> <Esc>:call nvim_win_close(b:win_id, v:true)<CR>
endfunction

function! s:ShowDebugMappings() abort
    let l:mappings = [
        \ '<Leader>dc: Continue',
        \ '<Leader>dt: Toggle Breakpoint',
        \ '<Leader>dT: Clear Breakpoints',
        \ '<Leader>dk: Restart',
        \ '<Leader>dh: Step Out',
        \ '<Leader>dl: Step Into',
        \ '<Leader>dj: Step Over',
        \ ]

	call s:ShowFloat(l:mappings)
endfunction

function! s:ShowLspMappings() abort
	let l:mappings = [
		\ '<Leader>e: Show error message associated to code under cursor',
		\ 'gd: goto definition',
		\ 'K: show type/signature information',
		\ ]
	call s:ShowFloat(l:mappings)
endfunction

" Treesitter config
" nvim-treesitter configuration
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "python",
    "c",
    "cpp",
    "lua",
    "vim",
    "rust",
    "javascript",
    "typescript",
  },
  highlight = {
    enable = true,
  },
}
EOF

" Bufferline
" Configure bufferline.nvim
" In your init.lua or init.vim
set termguicolors
lua << EOF
    require("bufferline").setup{}
EOF
set hidden
let bufferline = {
  \ 'animation': 'ease',
  \ 'auto_hide': v:true,
  \ }

" Lualine
" using all default 
" lua << EOF
" 	require('lualine').setup{
" 		options = { theme = 'gruvbox' }
" 	}
" EOF


" NERDCommenter
" Add your preferred key mappings for NERDCommenter here
" For example:
nnoremap <Leader>cc <Plug>NERDCommenterToggle
vnoremap <Leader>cc <Plug>NERDCommenterToggle

" Autopairs
" Enable nvim-autopairs
lua << EOF
    require('nvim-autopairs').setup{}

    -- Enable autopairs in all buffers
    require('nvim-autopairs').enable()
EOF

" color TODOs
lua << EOF
    require('todo-comments').setup {
        highlight = {
            keyword = 'TODO',
            altKeywords = {'FIXME', 'BUG', 'HACK'},
            -- Any other keywords you want to highlight
        },
        signs = true, -- Enable signs for each keyword
        -- Other configuration options
    }
    vim.keymap.set("n", "]t", function()
      require("todo-comments").jump_next()
    end, { desc = "Next todo comment" })

    vim.keymap.set("n", "[t", function()
      require("todo-comments").jump_prev()
    end, { desc = "Previous todo comment" })
EOF

" My remappings

colorscheme onedark

set autoindent
set tabstop=4
set shiftwidth=4
set number
" no word wrap after colum 80
set wrap " display lines as wrapped 
set tw=0 " do not physically wrap lines (inserting newlines)

" relative line numbering (makes jumps easier)
set relativenumber

" Use space characters instead of tabs.
" set expandtab

" Forget about swap files (but still save them)
set shortmess+=A

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest
" Change windows
nnoremap <Space>h <C-w>h
nnoremap <Space>l <C-w>l
nnoremap <Space>k <C-w>k
nnoremap <Space>j <C-w>j
nnoremap qq :q<CR>

nnoremap <C-x>n :bnext<CR>
nnoremap <C-x>p :bprev<CR>
nnoremap <C-t> :enew<CR>
nnoremap <C-w> :bdelete<CR>
" Force delete
nnoremap <C-w>! :bdelete!<CR>
