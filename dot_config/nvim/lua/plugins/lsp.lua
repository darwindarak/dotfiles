--------------------------------------------------------------------------------
-- LSP and Completion Configuration
-- This file configures:
-- 1. nvim-lspconfig for LSP support
-- 2. neodev.nvim for Neovim Lua development
-- 3. blink.cmp for completion
-- 4. conform.nvim for formatting
--------------------------------------------------------------------------------

return {
	--------------------------------------------------------------------------------
	-- Completion Engine
	--------------------------------------------------------------------------------
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = "rafamadriz/friendly-snippets",
		opts = {

			-- version = "v0.10.0",

			-- Keymap configuration
			-- Available presets:
			-- - 'default': Similar to built-in Neovim completion
			-- - 'super-tab': Similar to VSCode (tab to accept, arrows to navigate)
			-- - 'enter': Like 'super-tab' but uses Enter to accept
			keymap = { preset = "default" },

			-- Visual appearance settings
			appearance = {
				-- Fall back to nvim-cmp highlight groups if theme doesn't support blink.cmp
				use_nvim_cmp_as_default = true,

				-- Nerd Font configuration for icon alignment
				-- 'mono' for Nerd Font Mono, 'normal' for standard Nerd Font
				nerd_font_variant = "mono",
			},

			-- Configure completion sources
			-- These can be extended elsewhere in config using opts_extend
			sources = {
				default = {
					"lsp", -- LSP suggestions
					"path", -- file system paths
					"snippets", -- code snippets
					"buffer", -- words from current buffer
				},
			},
		},
		opts_extend = { "sources.default" },
	},

	--------------------------------------------------------------------------------
	-- LSP Configuration
	--------------------------------------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		-- Load on file operations
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		dependencies = { "saghen/blink.cmp" },

		opts = {
			-- List the LSP servers we want to run
			servers = {

				-- Custom Lua LSP specifically for neovim configs
				-- copied straight from lspconfig wiki
				lua_ls = {
					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc")
							then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									-- Depending on the usage, you might want to add additional paths here.
									-- "${3rd}/luv/library"
									-- "${3rd}/busted/library",
								},
								-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
								-- library = vim.api.nvim_get_runtime_file("", true)
							},
						})
					end,
					settings = {
						Lua = {},
					},
				},

				-- Rust LSP Configuration
				rust_analyzer = {},
				-- Markdown LSP Configuration
				marksman = {},

				gopls = {},
				svelte = {},
				sqls = {},
				ansiblels = {},
			},
		},

		-- Default setup function for LSP servers
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			for server, config in pairs(opts.servers) do
				-- Inject capabilities for blink.cmp integration
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
		end,
	},

	--------------------------------------------------------------------------------
	-- Formatting Configuration (conform.nvim)
	--------------------------------------------------------------------------------
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>=g",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},

		-- Configure formatters for different file types
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					haskell = { "fourmolu" },
					typescript = { "prettier" },
					svelte = { "prettierd" },
					html = { "prettier" },
					css = { "prettier" },
					json = { "jq" },
					python = { "isort", "blue" },
					lua = { "stylua" },
				},
				format_after_save = {
					lsp_fallback = true,
					async = true,
					-- timeout_ms = 500,
				},
			})
		end,
		opts = {},
	},

	--------------------------------------------------------------------------------
	-- Neovim Lua Development Tools
	--------------------------------------------------------------------------------
	{ "folke/neodev.nvim", opts = {} },
}
