local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then
  return
end

local ok_snip, luasnip = pcall(require, "luasnip")

lvim.builtin.cmp.sources = {
  { name = "copilot", priority = 1000 },
  { name = "nvim_lsp", priority = 900 },
  { name = "luasnip", priority = 800 },
  { name = "buffer", priority = 700 },
  { name = "path", priority = 600 },
}

lvim.builtin.cmp.mapping["<C-j>"] =
  cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })

lvim.builtin.cmp.mapping["<C-k>"] =
  cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })

lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.confirm({ select = true })
  elseif ok_snip and luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end, { "i", "s" })

lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
  elseif ok_snip and luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end, { "i", "s" })
