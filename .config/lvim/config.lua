-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
lvim.colorscheme = "habamax"

-- Make LuaRocks modules visible to Neovim/LuaJIT (macOS)
local _, _ = pcall(function()
  local home = os.getenv("HOME")
  package.path = package.path
    .. ";" .. home .. "/.luarocks/share/lua/5.1/?.lua"
    .. ";" .. home .. "/.luarocks/share/lua/5.1/?/init.lua"
  package.cpath = package.cpath
    .. ";" .. home .. "/.luarocks/lib/lua/5.1/?.so"
end)

vim.opt.number = true
vim.opt.relativenumber = true

lvim.plugins = lvim.plugins or {}

table.insert(lvim.plugins, {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  config = function()
    require("dressing").setup({})
  end,
})


table.insert(lvim.plugins, require("my-plugins.copilot"))
table.insert(lvim.plugins, require("my-plugins.copilot-cmp"))
table.insert(lvim.plugins, require("my-plugins.avante"))
table.insert(lvim.plugins, require("my-plugins.multicursor"))

require("my-config.copilot-cmp")

vim.opt.autoread = true

-- Trigger autoread when the buffer is entered or the cursor moves
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
