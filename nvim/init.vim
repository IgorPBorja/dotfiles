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

    " Plugin for configuring LSP
    Plug 'neovim/nvim-lspconfig'

    " Plugin that provides a completion engine for neovim
    Plug 'hrsh7th/nvim-cmp'
    " Snippet plugin
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'hrsh7th/cmp-nvim-lsp'

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
    
	" Creating, renaming, deleting and copying files with this telescope picker
	Plug 'nvim-telescope/telescope-file-browser.nvim'

    " Lualine: useful information (mode, git branch, etc)
    " NOT USING FOR NOW (MAKES NEOVIM SLOW)
    " Plug 'nvim-lualine/lualine.nvim'
call plug#end()

lua << EOF
    -- Setup LSP for C++
    local lspconfig = require('lspconfig')

    lspconfig.clangd.setup{
        cmd = { "clangd", "--clang-tidy", "--completion-style=detailed", "--suggest-missing-includes", "--header-insertion=iwyu", "--cross-file-rename"},
        filetypes = { "c", "cpp", "objc", "objcpp" },
        settings = {
            ["clangd"] = {
                compileFlags = {"-std=c++17"},
            }
        }
    }
    lspconfig.pyright.setup{}
EOF

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


" global commands
lua << EOF
	vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename)
EOF

" Autocomplete Configuration
lua << EOF
    -- Enable LSP completion
    -- vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Set completeopt to have a better completion experience
    vim.o.completeopt = 'menuone,noselect'

    local cmp = require('cmp')
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      -- Enable documentation window alongside completion menu
      window = {
         completion = cmp.config.window.bordered(),
         documentation = cmp.config.window.bordered(),        
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      },
    }
EOF

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

" Setup for Telescope file_browser picker 
" See repo https://github.com/nvim-telescope/telescope-file-browser.nvim
lua <<
	-- You don't need to set any of these options.
	-- IMPORTANT!: this is only a showcase of how you can set default options!
	require("telescope").setup {
		extensions = {
			file_browser = {
                theme = "ivy",
                -- disables netrw and use telescope-file-browser in its place
                hijack_netrw = true,
                mappings = {
					["i"] = {
                        -- your custom insert mode mappings
                    },
				    ["n"] = {
					    -- your custom normal mode mappings
					},
				},
			},
        },
    }
	-- To get telescope-file-browser loaded and working with telescope,
	-- you need to call load_extension, somewhere after setup function:
	require("telescope").load_extension "file_browser"

	-- open file_browser with the path of the current buffer
	-- show hidden files by default
	vim.api.nvim_set_keymap(
	  "n",
	  "<space>fb",
	  ":Telescope file_browser hidden=true path=%:p:h select_buffer=true<CR>",
	  { noremap = true  }
	)
.

" Vimspector stuff

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

tnoremap <Esc> <C-\><C-n>
