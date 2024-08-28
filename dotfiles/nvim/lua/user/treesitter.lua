local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
}

function M.config()
  require("nvim-treesitter.configs").setup {
    modules =  {},
    ensure_installed = { "lua", "markdown", "bash", "python", "go", "gomod", "gowork", "gosum", "ron", "rust", "toml", "yaml", "css", "html", "json", "json5", "jsonc", "elixir", "heex", "eex" },
    sync_install = false,
    ignore_install = { "javascript" },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  }
end

return M
