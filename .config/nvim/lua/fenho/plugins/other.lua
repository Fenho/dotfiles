return {
  "rgroli/other.nvim",

  config = function()
    require("other-nvim").setup({
      mappings = {
        "rails",
        {
          pattern = "/engines/(.*)/app/(.*).rb$",
          target = "/spec/engines/%1/%2_spec.rb",
          context = "test",
        },
        {
          pattern = "/spec/engines/(%w+)/(.*)_spec.rb$",
          target = "/engines/%1/app/%2.rb",
          context = "implementation",
        },
        {
          pattern = "/src/(.*)/(.*).ts$",
          target = "/src/%1/__tests__/%2.test.ts",
          context = "test",
        },
        {
          pattern = "/src/(.*)/__tests__/(.*).test.ts$",
          target = "/src/%1/%2.ts",
          context = "implementation",
        },
        {
          pattern = "/src/(.*)/(.*).vue$",
          target = "/src/%1/__tests__/%2.test.ts",
          context = "test",
        },
        {
          pattern = "/src/(.*)/__tests__/(.*).test.ts$",
          target = "/src/%1/%2.vue",
          context = "component",
        },
      },
    })
  end,
  keys = {
    {
      "<leader>gt",
      "<cmd>:Other<cr>",
      desc = "Open other.nvim",
    },
  },
}
