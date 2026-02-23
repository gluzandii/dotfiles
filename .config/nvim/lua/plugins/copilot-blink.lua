return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        trigger = {
          show_on_insert = false,
          show_on_keyword = true,
        },
        menu = {
          auto_show = true,
          auto_show_delay_ms = 0,
        },
      },
      keymap = {
        preset = "default",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        -- ["<Esc>"] = { "hide", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      local group = vim.api.nvim_create_augroup("BlinkCmpAutoShow", { clear = true })
      local timer = vim.uv.new_timer()

      local function schedule_show()
        timer:stop()
        timer:start(50, 0, vim.schedule_wrap(function()
          if vim.fn.mode() ~= "i" then return end
          local cmp = require("blink.cmp")
          if not cmp.is_menu_visible() then cmp.show() end
        end))
      end

      vim.opt.updatetime = 800

      vim.api.nvim_create_autocmd("CursorHoldI", {
        group = group,
        callback = schedule_show,
      })

      vim.api.nvim_create_autocmd("InsertLeave", {
        group = group,
        callback = function() timer:stop() end,
      })
    end,
    dependencies = {
      {
        "fang2hou/blink-copilot",
      },
    },
  },
}