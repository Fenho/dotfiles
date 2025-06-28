return {
	"nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			autoinstall = true,
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "vue", "ruby", "terraform" },
			highlight = { enable = true },
			indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
		})
	end,
}
