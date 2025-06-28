return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
    "BurntSushi/ripgrep",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"LukasPietzschmann/telescope-tabs",
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			version = "^1.0.0",
		},
	},
	config = function()
		local telescope = require("telescope")
    local lga_actions = require("telescope-live-grep-args.actions")
		local actions = require("telescope.actions")
		telescope.load_extension("live_grep_args")
		telescope.load_extension("telescope-tabs")

		telescope.setup({
      extensions = {
        live_grep_args = {
          -- define mappings, e.g.
          -- ... also accepts theme settings, for example:
          -- theme = "dropdown", -- use dropdown theme
          -- theme = { }, -- use own theme spec
          -- layout_config = { mirror=true }, -- mirror preview pane
        }
      },
			defaults = {
				path_display = { "truncate " },
				mappings = {
					i = {
            auto_quoting = true, -- enable/disable auto-quoting
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-w>"] = actions.delete_buffer,
            ["<C-p>"] = lga_actions.quote_prompt(),
            ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --glob " }),
            -- freeze the current list and start a fuzzy search in the frozen list
            ["<C-r>"] = actions.to_fuzzy_refine,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>gf", "<cmd>Telescope git_files<cr>", { desc = "Fuzzy find git files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set(
			"n",
			"<leader>fs",
			":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
			{ desc = "Find string in cwd" }
		)
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
		keymap.set("n", "<leader>ft", "<cmd>Telescope telescope-tabs list_tabs<cr>", { desc = "Find tabs" })
    keymap.set(
      "n",
      "<leader>fo",
      ":lua require('telescope.builtin').live_grep({additional_args = function(opts) return {'--max-count=1'} end})",
      { desc = "Find grep one file per match" }
    )
	end,
}
