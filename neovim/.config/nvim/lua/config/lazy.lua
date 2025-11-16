-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","

require("lazy").setup({
	{ "scwood/vim-hybrid" },
	"nvim-tree/nvim-tree.lua",
	{ "jwalton512/vim-blade" },
	{ "StanAngeloff/php.vim" },
	{ "Yggdroot/indentLine" },
	{ "vim-scripts/bash-support.vim" },
	{ "roosta/srcery" },
	{ "editorconfig/editorconfig-vim" },
	{ "dracula/vim" },
	{ "rking/ag.vim" },
	{ "skwp/greplace.vim" },
	{ "tpope/vim-surround" },
	{ "fatih/vim-go", build = ":GoInstallBinaries" },
	{ "sebdah/vim-delve" },
	{ "airblade/vim-gitgutter" },
	{
		"junegunn/fzf",
		build = function()
			vim.fn["fzf#install"]()
		end,
	},
	{ "junegunn/fzf.vim" },
	{ "zivyangll/git-blame.vim" },
	{ "easymotion/vim-easymotion" },
	{ "rust-lang/rust.vim" },
	{ "mhartington/formatter.nvim" },
	{ "hat0uma/csvview.nvim" },
	{ "folke/tokyonight.nvim" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "mfussenegger/nvim-dap" },
	{ "nvim-neotest/nvim-nio" },
	{ "rcarriga/nvim-dap-ui" },
	{ "leoluz/nvim-dap-go" },
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp", -- LSP completions
	"hrsh7th/cmp-buffer", -- Buffer completions
	"hrsh7th/cmp-path", -- Path completions
	"hrsh7th/cmp-cmdline", -- Command-line completions
	"L3MON4D3/LuaSnip", -- Snippet support
	"saadparwaiz1/cmp_luasnip", -- Snippet completions
	{ "nvim-telescope/telescope.nvim", tag = "0.1.8" },
	{ "EdenEast/nightfox.nvim" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"Exafunction/windsurf.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({
				-- Optionally disable cmp source if using virtual text only
				enable_cmp_source = false,
				enable_chat = true,
				virtual_text = {
					enabled = true,
				},
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>`",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"yetone/avante.nvim",
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- ⚠️ must add this setting! ! !
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			-- add any opts here
			-- this file can contain specific instructions for your project
			-- instructions_file = "avante.md",
			-- for example
			stream = true,
			provider = "openrouter",
			providers = {
				openrouter = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					model = "x-ai/grok-4-fast",
					model_names = {
						"x-ai/grok-4-fast:free",
						"google/gemini-2.0-flash-001",
						"x-ai/grok-4-fast",
					},
					api_key_name = "OPENROUTER_API_KEY",
					extra_headers = {
						["HTTP-Referer"] = "https://github.com/yetone/avante.nvim",
						["X-Title"] = "Neovim Avante",
					},
				},
			},
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub and hub:get_active_servers_prompt() or ""
			end,
			-- Using function prevents requiring mcphub before it's loaded
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
		config = function()
			require("mcphub").setup()
		end,
	},
})
