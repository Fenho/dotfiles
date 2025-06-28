return {
	"folke/zen-mode.nvim",
	version = "*",
	vim.keymap.set("n", "<leader>zm", "<cmd>ZenMode<CR>"),
  config = function()
      require("zen-mode").setup({
          window = {
              backdrop = 0.95, -- shade the backdrop of the Zen window. Set to false to keep the same window color.
              width = .5, -- width of the Zen window
              height = 1, -- height of the Zen window
          },
      })
  end,
}
