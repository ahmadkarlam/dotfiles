require("config.lazy")

local fn = vim.fn
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd
local tb = require("telescope.builtin")

-- Plugin configurations
require("dap-go").setup()
require("mason").setup()
require("mason-lspconfig").setup()
require("csvview").setup()
require("config")
require("config.cmp")
require("lualine").setup()
require("nvim-tree").setup({})

-- lspconfig
vim.lsp.config["intelephense"] = {}
vim.lsp.enable("intelephense")
-- lspconfig.intelephense.setup({})

vim.lsp.config["gopls"] = {}
vim.lsp.enable("gopls")
-- lspconfig.gopls.setup{
--     on_attach = function(client, bufnr)
--         -- Add additional LSP setup here if needed
--     end,
--     capabilities = require'cmp_nvim_lsp'.default_capabilities(),
-- }

vim.lsp.config["jdtls"] = {}
vim.lsp.enable("jdtls")
-- lspconfig.jdtls.setup({})

vim.lsp.config["clangd"] = {}
vim.lsp.enable("clangd")
-- lspconfig.clangd.setup({})

-- Editor settings
opt.linespace = 20
opt.wrap = false
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.swapfile = false
opt.autoindent = true
opt.shiftwidth = 4
opt.autowrite = true
opt.showcmd = true
opt.mouse = "a"
opt.showmode = false
opt.complete = ".,w,b,u"
opt.backspace = "indent,eol,start"
opt.relativenumber = true
opt.wildmenu = true
opt.colorcolumn = "120"
opt.splitbelow = true
opt.splitright = true
opt.clipboard = "unnamed"
opt.hidden = true
opt.backup = false
opt.writebackup = false
opt.updatetime = 50
opt.cmdheight = 2
opt.wildignore:append({ "*/tmp/*", "*.so", "*.swp", "*.zip", "node_modules" })

-- Colorscheme
cmd("colorscheme nightfox")

-- Leader key
g.mapleader = ","

-- Keybindings
api.nvim_set_keymap("n", "<leader>w", ":w!<cr>", { noremap = true, silent = true, desc = "Save" })
api.nvim_set_keymap("n", "<leader>q", ":q<cr>", { noremap = true, silent = true, desc = "Close" })
api.nvim_set_keymap("i", "jj", "<esc>", { noremap = true, silent = true, desc = "Esc" })

-- Window navigation
api.nvim_set_keymap("n", "<C-J>", "<C-W><C-J>", { noremap = true })
api.nvim_set_keymap("n", "<C-K>", "<C-W><C-K>", { noremap = true })
api.nvim_set_keymap("n", "<C-L>", "<C-W><C-L>", { noremap = true })
api.nvim_set_keymap("n", "<C-H>", "<C-W><C-H>", { noremap = true })

-- NERDTree
-- api.nvim_set_keymap("n", "<C-e>", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
-- cmd("autocmd vimenter * NERDTree")
--
api.nvim_set_keymap("n", "<C-e>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- CtrlP
-- g.ctrlp_map = "<c-p>"
-- g.ctrlp_cmd = "CtrlP"
-- api.nvim_set_keymap("n", "<Leader>p", ":CtrlPBuffer<CR>", { noremap = true, silent = true })
-- api.nvim_set_keymap("n", "<C-r>", ":CtrlPBufTag<CR>", { noremap = true, silent = true })

-- Greplace
opt.grepprg = "ag"
g.grep_cmd_opts = "--line-numbers --noheading"

vim.keymap.set("n", "gd", tb.lsp_definitions, { noremap = true, silent = true, desc = "Go to definition" })
vim.keymap.set("n", "gr", tb.lsp_references, { noremap = true, silent = true, desc = "Find references" })
vim.keymap.set("n", "gi", tb.lsp_implementations, { noremap = true, silent = true, desc = "Go to implementation" })
vim.keymap.set("n", "gp", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "Hover code" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show error" })

-- Go settings
g.go_fmt_command = "goimports"
g.syntastic_go_checkers = { "govet", "errcheck", "go" }

-- Debugging (DAP)
api.nvim_set_keymap(
	"n",
	"<Leader>f",
	":lua require('dap').continue()<CR>",
	{ noremap = true, silent = true, desc = "Run/Debug" }
)
api.nvim_set_keymap(
	"n",
	"<Leader>fw",
	":lua require('dap').close()<CR>",
	{ noremap = true, silent = true, desc = "Close DAP" }
)
api.nvim_set_keymap(
	"n",
	"<F10>",
	":lua require('dap').step_over()<CR>",
	{ noremap = true, silent = true, desc = "Step over" }
)
api.nvim_set_keymap(
	"n",
	"<F11>",
	":lua require('dap').step_into()<CR>",
	{ noremap = true, silent = true, desc = "Step into" }
)
api.nvim_set_keymap(
	"n",
	"<F12>",
	":lua require('dap').step_out()<CR>",
	{ noremap = true, silent = true, desc = "Step out" }
)
api.nvim_set_keymap(
	"n",
	"<Leader>d",
	":lua require('dap').toggle_breakpoint()<CR>",
	{ noremap = true, silent = true, desc = "Toggle breakpoint" }
)
vim.keymap.set("n", "<leader>?", function()
	require("dapui").eval(nil, { enter = true })
end, { desc = "Evaluate variable" })

-- Disable default Easymotion mappings
g.EasyMotion_do_mapping = 0

-- `s{char}{char}{label}` motion
api.nvim_set_keymap("n", "s", "<Plug>(easymotion-overwin-f2)", {})

-- Enable case-insensitive search
g.EasyMotion_smartcase = 1

-- JK motions: Line motions
api.nvim_set_keymap("n", "f", "<Plug>(easymotion-bd-f)", { desc = "Jump char (before)" })
api.nvim_set_keymap("n", "t", "<Plug>(easymotion-bd-t)", { desc = "Jump char (after)" })
api.nvim_set_keymap("n", "<Leader>j", "<Plug>(easymotion-j)", { desc = "Jump char down" })
api.nvim_set_keymap("n", "<Leader>k", "<Plug>(easymotion-k)", { desc = "Jump char up" })

-- Formatter on save
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>p", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
