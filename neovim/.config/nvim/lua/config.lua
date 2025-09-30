-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		php = {
			function()
				return {
					exe = "./vendor/bin/pint",
					stdin = false,
					ignore_exitcode = false,
				}
			end,
		},

		go = {
			function()
				return {
					exe = "gofmt",
					stdin = true,
				}
			end,
		},

		sql = {
			function()
				return {
					exe = "sqlfluff",
					args = {
						"format",
						"--disable-progress-bar",
						"--dialect postgres",
						"--nocolor",
						"-",
					},
					stdin = true,
					ignore_exitcode = false,
				}
			end,
		},

		c = {
			function()
				return {
					exe = "clang-format",
					args = {
						"-assume-filename",
						util.escape_path(util.get_current_buffer_file_name()),
					},
					stdin = true,
					try_node_modules = true,
				}
			end,
		},

		lua = {
			require("formatter.filetypes.lua").stylua,
			function()
				-- Full specification of configurations is down below and in Vim help
				-- files
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},

		json = {
			require("formatter.filetypes.json").jq,
		},

		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
			-- Remove trailing whitespace without 'sed'
			-- require("formatter.filetypes.any").substitute_trailing_whitespace,
		},
	},
})

local dap, dapui = require("dap"), require("dapui")
local dapgo = require("dap-go")
dapui.setup()
dapgo.setup()
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end

-- Include the next few lines until the comment only if you feel you need it
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

dap.adapters.go = {
	type = "server",
	port = "${port}",
	executable = {
		command = "dlv",
		args = { "dap", "-l", "127.0.0.1:${port}", "--log" },
	},
}

dap.configurations.go = {
	{
		type = "go", -- Matches the adapter type above
		name = "Debug",
		request = "launch",
		program = "${file}", -- Debug the current file
		outputMode = "remote",
		console = "integratedTerminal",
	},
	{
		type = "go",
		name = "Debug Package with Log",
		request = "launch",
		program = "${workspaceFolder}", -- Debug the package in the current directory
		outputMode = "remote",
	},
	{
		type = "go",
		name = "Attach",
		request = "attach",
		processId = require("dap.utils").pick_process, -- Pick a running process
		outputMode = "remote",
	},
}

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the listed parsers MUST always be installed)
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "php", "go" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		enable = true,
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})
