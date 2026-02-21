return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      -- Disable Copilot's inline suggestions so it does NOT hijack <Tab>.
      -- We'll use Copilot via the completion menu (blink) instead.
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
}