return {
	"supermaven-inc/supermaven-nvim",
	config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { cpp = true },
      -- color = {
      --   suggestion_color = "#ffffff",
      --   cterm = 244,
      -- },
      log_level = "info", -- set to "off" to disable logging completely
      disable_inline_completion = false, -- disables inline completion for use with cmp
      disable_keymaps = false, -- disables built in keymaps for more manual control
      condition = function()
        return false
      end -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
    })
    vim.keymap.set('n', '<leader>tia', function()
      local supermaven = require("supermaven-nvim")
      local api = require("supermaven-nvim.api")
      if supermaven.disable_inline_completion then
        api.toggle()
        print("Inline AI autocompletion ENABLED")
      else
        api.toggle()
        print("Inline AI autocompletion DISABLED")
      end
    end, { desc = '[T]oggle [I]nline [A]I autocompletion' })
	end,
}
