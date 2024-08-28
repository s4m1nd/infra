local M = {
  "nvim-neotest/nvim-nio",
  event = "VeryLazy",
}

function M.config()
  require("nio")
end

return M
