local M = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  }
}

function M.config()
  local null_ls = require "null-ls"

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics

  null_ls.setup {
    debug = false,
    sources = {
      formatting.stylua,
      formatting.prettier.with {
        extra_filetypes = { "toml", "scss", "css", "html", "javascript", "typescript", "json", "yaml", "markdown" },
        extra_args = { "--single-quote", "--jsx-single-quote" },
      },
      formatting.black,
      diagnostics.flake8,
      null_ls.builtins.completion.spell,
      null_ls.builtins.code_actions.gomodifytags,
      null_ls.builtins.code_actions.impl,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.gofumpt,
    },
  }
end

return M

