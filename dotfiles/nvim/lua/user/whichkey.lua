local M = {
  "folke/which-key.nvim",
}

function M.config()
  local which_key = require "which-key"

  which_key.setup {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
      },
    },
    -- Change 'window' to 'win'
    win = {
      border = "rounded",
      position = "bottom",
      padding = { 2, 2, 2, 2 },
    },
    -- Remove 'ignore_missing' option
    show_help = false,
    show_keys = false,
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt" },
    },
  }

  local mappings = {
    ["<leader>q"] = { "<cmd>confirm q<CR>", "Quit" },
    ["<leader>h"] = { "<cmd>nohlsearch<CR>", "NOHL" },
    ["<leader>;"] = { "<cmd>tabnew | terminal<CR>", "Term" },
    ["<leader>v"] = { "<cmd>vsplit<CR>", "Split" },
    ["<leader>b"] = { name = "Buffers" },
    ["<leader>d"] = { name = "Debug" },
    ["<leader>f"] = { name = "Find" },
    ["<leader>g"] = { name = "Git" },
    ["<leader>l"] = { name = "LSP" },
    ["<leader>p"] = { name = "Plugins" },
    ["<leader>t"] = { name = "Test" },
    ["<leader>a"] = {
      name = "Tab",
      n = { "<cmd>$tabnew<cr>", "New Empty Tab" },
      N = { "<cmd>tabnew %<cr>", "New Tab" },
      o = { "<cmd>tabonly<cr>", "Only" },
      h = { "<cmd>-tabmove<cr>", "Move Left" },
      l = { "<cmd>+tabmove<cr>", "Move Right" },
    },
    ["<leader>T"] = { name = "Treesitter" },
    ["<leader>e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
    ["<leader>gg"] = { "<cmd>Neogit<CR>", "Neogit" },
  }

  which_key.register(mappings, { mode = "n", prefix = "<leader>" })
end

return M
