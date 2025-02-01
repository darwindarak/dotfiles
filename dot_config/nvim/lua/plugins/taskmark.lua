return {
	"taskmark",
	dir = "~/projects/taskmark",
	config = function()
		require("taskmark").setup({})
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- Treesitter is a dependency
	},
	lazy = false,
}
