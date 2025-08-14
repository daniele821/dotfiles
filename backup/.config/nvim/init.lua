-- options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.statusline = "%<%f %m%r%y %= %{&ff} %l:%v %P"
vim.opt.laststatus = 3
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.mousemodel = "extend"
vim.opt.pumheight = 15
vim.opt.swapfile = false

-- keymaps
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "grf", "")

-- autocmd
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	callback = function()
		vim.hl.on_yank()
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	desc = "Disable autocommenting",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- install lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- install plugins using lazy
require("lazy").setup({
	{
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			require("onedark").setup({ style = "deep" })
			require("onedark").load()
		end,
	},
	{
		"stevearc/oil.nvim",
		keys = {{ "-", function() if vim.api.nvim_win_get_config(0).relative == "" then require("oil").open() end end }},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			default_file_explorer = true,
			view_options = {
				show_hidden = true,
			},
			keymaps = {
				["<CR>"] = "actions.select",
				["<C-c>"] = "actions.close",
				["<C-w><C-q>"] = "actions.close",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["~"] = { "actions.cd", opts = { scope = "tab" } },
				["<C-l>"] = "actions.refresh",
				["gx"] = "actions.open_external",
				["gh"] = { "actions.toggle_hidden" },
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "VeryLazy" },
		opts = {
			signs_staged_enable = true,
			signcolumn = true,
			watch_gitdir = { follow_files = true },
			auto_attach = true,
			attach_to_untracked = true,
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				vim.keymap.set({ "n", "v" }, "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { buffer = bufnr })
				vim.keymap.set({ "n", "v" }, "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { buffer = bufnr })
			end,
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<A-a>", function() require("telescope.builtin").builtin() end, mode = { "n", "i" } },
			{ "<A-h>", function() require("telescope.builtin").help_tags() end, mode = { "n", "i" } },
			{ "<A-f>", function() require("telescope.builtin").find_files() end, mode = { "n", "i" } },
			{ "<A-s-f>", function() require("telescope.builtin").find_files({ file_ignore_patterns = { "%.git/" }, hidden = true, }) end, mode = { "n", "i" } },
			{ "<A-b>", function() require("telescope.builtin").buffers({ only_cwd = true, }) end, mode = { "n", "i" } },
			{ "<A-s-b>", function() require("telescope.builtin").buffers() end, mode = { "n", "i" } },
			{ "<A-s-g>", function() require("telescope.builtin").grep_string() end, mode = { "n", "i" } },
			{ "<A-g>", function() require("telescope.builtin").live_grep() end, mode = { "n", "i" } },
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<C-c>"] = actions.close,
							["<a-f>"] = function() require("telescope.builtin").find_files() end,
						},
						n = {
							["<esc>"] = actions.close,
							["<C-c>"] = actions.close,
						},
					},
				},
			})
		end,
	},
}, {
	change_detection = {
		enabled = false,
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tohtml",
				"tutor",
				"zipPlugin",
				"tarPlugin",
				"osc52",
				"shada",
				"spellfile",
				"man",
				"editorconfig",
				"netrwPlugin",
				"rplugin",
				-- "matchit",
				"matchparen",
			},
		},
	},
})
