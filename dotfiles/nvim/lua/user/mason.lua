local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
}


function M.config()
  local servers = {
    "goimports",
    "gofumpt",
    "gomodifytags",
    "impl",
    "delve",
    "lua_ls",
    "cssls",
    "html",
    "typescript",
    "tsx",
    "tsserver",
    "pyright",
    "bashls",
    "jsonls",
    "prettier",
  }

  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }

  require("mason-lspconfig").setup {
    ensure_installed = servers,
  }
end

return M
