-- local M = {
--   "LunarVim/darkplus.nvim",
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
-- }

-- function M.config()
--   vim.cmd.colorscheme "darkplus"
-- end


-- local M = {
--   "morhetz/gruvbox",
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
-- }

-- local M = {
--   "Shatur/neovim-ayu",
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
-- }
--
--
-- function M.config()
--   vim.cmd.colorscheme "ayu"
-- end

-- local M = {
--   "kepano/flexoki-neovim",
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
-- }
--
-- function M.config()
--   vim.cmd.colorscheme "flexoki-dark"
-- end

-- local M = {
--   "olivercederborg/poimandres.nvim",
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
-- }
--
-- function M.config()
--   vim.cmd.colorscheme "poimandres"
-- end

-- local M = {
--   "hachy/eva01.vim",
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
-- }
--
-- function M.config()
--   vim.cmd.colorscheme "eva01"
-- end

local M = {
  "aktersnurra/no-clown-fiesta.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

function M.config()
  vim.cmd.colorscheme "no-clown-fiesta"
end

-- local M = {
--   "rose-pine/neovim",
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
-- }
--
-- function M.config()
--   vim.cmd.colorscheme "rose-pine-dawn"
-- end
--
-- return M

return M
