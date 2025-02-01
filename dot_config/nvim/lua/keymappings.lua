--------------------------------------------------------------------------------
-- Keybinding Configuration
-- This file defines custom keybindings for various Neovim operations
-- Most bindings use <Leader> prefix (set to space in init.lua)
--------------------------------------------------------------------------------

-- Helper function to create keymappings
-- @param mode: The mode the keybinding works in (n=normal, v=visual, etc)
-- @param key: The key sequence to trigger the command
-- @param command: The command to execute
-- @param desc: Description of what the keybinding does
local key_mapper = function(mode, key, command, desc)
	vim.api.nvim_set_keymap(mode, key, command, { noremap = true, silent = true, desc = desc })
end

--------------------------------------------------------------------------------
-- UI Toggles
--------------------------------------------------------------------------------
key_mapper("n", "<Leader>t\\", "<cmd>Neotree toggle<CR>", "Toggle Neotree")
key_mapper(
	"n",
	"<Leader>t#",
	"<cmd>lua vim.opt.relativenumber = not vim.opt.relativenumber:get()<CR>",
	"Toggle relative line numbers"
)
key_mapper(
	"n",
	"<Leader>tb",
	"<cmd>lua vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'<CR>",
	"Toggle background"
)
key_mapper("n", "<Leader>ts", "<cmd>AerialToggle<CR>", "Toggle symbols")

--------------------------------------------------------------------------------
-- Process runners
--------------------------------------------------------------------------------
key_mapper("n", "<Leader>rt", "<cmd>lua require('neotest').run.run()<CR>", "Run tests")

--------------------------------------------------------------------------------
-- Buffer Management
--------------------------------------------------------------------------------
key_mapper("n", "<Leader>bw", "<cmd>bwipeout<CR>", "Remove buffer")
key_mapper("n", "<Leader>bb", "<cmd>b#<CR>", "Previous buffer")
key_mapper("n", "<Leader>bl", "<cmd>Telescope buffers<CR>", "List buffers")
key_mapper("n", "<Leader>bd", "<cmd>lua Snacks.bufdelete()<CR>", "Delete buffer")

--------------------------------------------------------------------------------
-- LSP Navigation
--------------------------------------------------------------------------------
key_mapper("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "Delete buffer")
key_mapper("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "Delete buffer")
key_mapper("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", "Show code actions")

--------------------------------------------------------------------------------
-- Project Navigation
--------------------------------------------------------------------------------
-- key_mapper("n", "<Leader>pf", "<cmd>Telescope find_files find_command=rg,--files<CR>", "Pick project files")
key_mapper("n", "<Leader>pf", "<cmd>lua Snacks.picker.files()<CR>", "Pick project files")
key_mapper(
	"n",
	"<Leader>pF",
	"<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<CR>",
	"Pick all project files"
)

--------------------------------------------------------------------------------
-- Miscellaneous
--------------------------------------------------------------------------------
key_mapper("n", "<Leader>/", "<cmd>Telescope live_grep<CR>", "Live grep")
key_mapper("n", "<Leader>x", "<cmd>Telescope commands<CR>", "Pick commands")

key_mapper("n", "<leader>$", ":IncRename ", "LSP rename")

-- Clear search highlighting
key_mapper("n", "<esc><esc>", "<cmd>nohls<CR>")

vim.keymap.set({ "n", "v" }, "<Leader>=", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = "Format buffer" })
