return {
  "kevinhwang91/nvim-bqf",
  config = function()
    require("bqf").setup({
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        border_hl = "FloatBorder",
      },
    })
  end,
}
