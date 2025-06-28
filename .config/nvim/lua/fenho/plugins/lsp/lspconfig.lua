return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
		{ "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")

		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gy", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp tYpe definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = { -- custom settings for lua
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								-- make language server aware of runtime files
								library = {
									[vim.fn.expand("$VIMRUNTIME/lua")] = true,
									[vim.fn.stdpath("config") .. "/lua"] = true,
								},
							},
						},
					},
				})
			end,
			["ts_ls"] = function()
				lspconfig["ts_ls"].setup({
					capabilities = capabilities,
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "json" },
				})
			end,
			["volar"] = function()
        local function get_typescript_lib_path()
          local root_dir = vim.fs.dirname(vim.fs.find({'package.json', 'tsconfig.json', '.git'}, { upward = true })[1])
          if root_dir then
            local typescript_lib = root_dir .. "/node_modules/typescript/lib"
            if vim.fn.isdirectory(typescript_lib) == 1 then
              return typescript_lib
            end
          end
          return ""
        end

        require("lspconfig").volar.setup({
          capabilities = capabilities,
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = true,
            },
            typescript = {
              tsdk = get_typescript_lib_path(),
            },
          },
          on_new_config = function(new_config, new_root_dir)
            new_config.init_options.typescript.tsdk = new_root_dir .. "/node_modules/typescript/lib"
          end,
        })
      end,
			["ruby_lsp"] = function()
				lspconfig["ruby_lsp"].setup({
					capabilities = capabilities,
          cmd = { "bundle", "exec", "ruby-lsp" },
          filetypes = { "ruby", "rbi" },
          root_dir = util.root_pattern("Gemfile", ".git", "Gemfile.lock")
				})
			end,
			["sorbet"] = function()
				lspconfig["sorbet"].setup({
					capabilities = capabilities,
          filetypes = { "ruby", "rbi" },
				})
			end,
			["rubocop"] = function()
				lspconfig["rubocop"].setup({
					capabilities = capabilities,
          filetypes = { "ruby", "rbi" },
				})
			end,
      ["terraform"] = function()
        lspconfig["terraform"].setup({
          capabilities = capabilities,
          cmd = { "terraform-lsp" },
          filetypes = { "terraform" },
          root_dir = util.root_pattern("go.mod", ".git")
        })
      end,
		})
	end,
}
