-- first i get the openfoam directory
-- and check if it's set
local openfoam_dir = vim.fn.expand('$WM_PROJECT_DIR')
local openfoam_env_set = false

-- this part checks if the openfoam evnironment variable 
-- has been set
if openfoam_dir == '$WM_PROJECT_DIR' then
	openfoam_env_set = false
else
	openfoam_env_set = true
end

if openfoam_env_set then

	-- first, don't use the regular config file
	vim.opt.runtimepath:remove(vim.fn.expand('~/.config/nvim'))
	vim.opt.packpath:remove(vim.fn.expand('~/.local/share/nvim/site'))
	vim.opt.runtimepath:append(vim.fn.expand('$WM_PROJECT_DIR/nvim-config'))
	vim.opt.packpath:append(vim.fn.expand('$WM_PROJECT_DIR/nvim-config/packpath'))

	-- also don't use existing plugins 
	vim.opt.packpath:remove(vim.fn.expand('~/.local/share/nvim'))
	vim.opt.runtimepath:remove(vim.fn.expand('~/.local/share/nvim'))


	-- lazy plugin manager
	-- note: for lazy on Arch Linux, please install via AUR as well,
	-- it's easier...
	-- here's the default lazypath
	-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	local lazypath = vim.fn.expand('$WM_PROJECT_DIR/nvim-config/share/nvim') .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		-- make a local datapath
		vim.fn.system({
			"mkdir",
			"-p",
			vim.fn.expand('$WM_PROJECT_DIR/nvim-config/share/nvim'),
		})
		-- git clone lazy
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
	-- lazy plugin manager options: changes the lazy plugin manager install directory 
	-- to a different folder so you dont clash with an existing configuration
	local opts = {
		root = vim.fn.expand('$WM_PROJECT_DIR/nvim-config/share/nvim') .. "/lazy", 
	}


	-- basic options
	vim.opt.number = true
	vim.opt.relativenumber = true
	vim.opt.tabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.wrap = false

	-- makes scrolling easier
	vim.opt.scrolloff = 5

	-- for spelling
	vim.opt.spell = true
	vim.cmd("set spelllang=en_gb")


	-- syntax
	vim.cmd([[
	syntax on
	filetype indent on
	filetype plugin indent on
	]])

	-- enables vim-latex on all .tex files
	vim.cmd([[
	autocmd BufNewFile,BufRead *.tex set filetype=tex
	"autocmd BufNewFile,BufRead *.typ set filetype=typst
	]])

	-- color column
	vim.cmd("set cc=75")

	-- for NERDTree specifically
	vim.cmd([[
	let NERDTreeShowHidden=1
	]])


	-- disable netrw at the very start of your init.lua (strongly advised)
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	-- set termguicolors to enable highlight groups
	vim.opt.termguicolors = true



	local plugins = {

		-- git gutter (may clash with ubuntu's existing git-gutter
		-- if on linux mint)
		-- use 'vim-scripts/vim-gitgutter'
		'preservim/nerdtree',
		'morhetz/gruvbox',
		{'kepano/flexoki-neovim', name = 'flexoki'},
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
		{'kaarmu/typst.vim', ft = {'typst'}},
		{
			'VonHeikemen/lsp-zero.nvim',
			branch = 'v2.x',
			dependencies = {
				-- LSP Support
				{                                      -- Optional
				'williamboman/mason.nvim',
			},

			-- Autocompletion from snippets
			{'hrsh7th/nvim-cmp'},     -- Required
			{'hrsh7th/cmp-nvim-lsp'}, -- Required
			{'L3MON4D3/LuaSnip'},     -- Required

			-- buffer, path and commandline completion
			{'hrsh7th/cmp-buffer'},     -- Required
			{'hrsh7th/cmp-path'}, -- Required
			{'hrsh7th/cmp-cmdline'}, -- Required

		}
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"quangnguyen30192/cmp-nvim-ultisnips",
			config = function()
				-- optional call to setup (see customization section)
				require("cmp_nvim_ultisnips").setup{}
			end,
			-- If you want to enable filetype detection based on treesitter:
			-- requires = { "nvim-treesitter/nvim-treesitter" },
		}
	},

	-- telescope 
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.3',
		-- or                            , branch = '0.1.x',
		dependencies = { {'nvim-lua/plenary.nvim'} }
	},

	-- harpoon 
	'ThePrimeagen/harpoon',


	-- airline 
	'vim-airline/vim-airline',
	'vim-airline/vim-airline-themes',

	-- tagbar
	'preservim/tagbar',

	-- fugitive 
	'tpope/vim-fugitive',

	-- vim latex
	'vim-latex/vim-latex',

	-- vim align (in the arch repos)
	'junegunn/vim-easy-align',

	-- ultisnips and snippets
	'honza/vim-snippets',
	'hrsh7th/vim-vsnip',
	'hrsh7th/vim-vsnip-integ',
	'rafamadriz/friendly-snippets',

	-- hop nvim 
	{
		'smoka7/hop.nvim',
		version = '*',
		opts = {},
	},

	-- ccls plugin 
	'ranjithshegde/ccls.nvim',
}






vim.g.mapleader = "\\" -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup(plugins, opts)

-- telescope settings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- harpoon settings
require("telescope").load_extension('harpoon')
vim.cmd([[
nnoremap <leader>b <cmd>lua require("harpoon.mark").add_file()<cr>
nnoremap <leader><Esc> <cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>
nnoremap <leader>q <cmd>Telescope harpoon marks<cr>
]])

-- Mason Lsp Setup manager (must load after lazy plugins start)
-- also change the install directory to a different folder so we don't 
-- clash with local mason setups
-- require("mason").setup({
--     install_root_dir = vim.fn.expand('./nvim-config/share/nvim') .. "/mason",
-- })
-- vim.opt.runtimepath:append(vim.fn.expand('./nvim-config/share/nvim') .. "/mason")
-- vim.opt.packpath:append(vim.fn.expand('./nvim-config/share/nvim') .. "/mason")
--
-- Nevermind, I'll let mason use the regular configured lsp servers...

require("mason").setup()
require("mason-lspconfig").setup{
	ensure_installed = { "lua_ls" },
}

-- lsp settings 
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())


-- for typst
require 'lspconfig'.typst_lsp.setup {}

lsp.setup()
-- for completion

local cmp = require 'cmp'

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			--vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, -- For vsnip users.
		--{ name = 'luasnip' }, -- For luasnip users.
		--{ name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
		{ name = 'buffer' , option = {
			get_bufnrs = function()
				return vim.api.nvim_list_bufs()
			end
		}
	},
	{ name = 'path' },
})
})

-- keybindings



-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,

})

-- colorscheme
vim.cmd([[
"colorscheme gruvbox
"set background=dark
colorscheme flexoki-dark
let g:airline_theme='dark'
set cc=75
]])

-- hop nvim
local hop = require('hop')
local directions = require('hop.hint').HintDirection

vim.keymap.set('','f', function()
	hop.hint_words({direction = directions.AFTERCURSOR})
end
, {remap=true})



-- for ccls setup 
require("./lua/ccls-setup")
end
