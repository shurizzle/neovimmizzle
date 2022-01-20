local M = {}

function M.config()
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  local kind_icons = {
    Class = '',
    Color = '',
    Constant = 'ﲀ',
    Constructor = '',
    Enum = '練',
    EnumMember = '',
    Event = '',
    Field = '',
    File = '',
    Folder = '',
    Function = '',
    Interface = 'ﰮ ',
    Keyword = '',
    Method = '',
    Module = '',
    Operator = '',
    Property = '',
    Reference = '',
    Snippet = '',
    Struct = '',
    Text = '',
    TypeParameter = '',
    Unit = '塞',
    Value = '',
    Variable = '',
  }
  local source_names = {
    nvim_lsp = '[Lsp]',
    luasnip = '[Snp]',
    buffer = '[Buf]',
    nvim_lua = '[Lua]',
    path = '[Pat]',
    calc = '[Clc]',
    emoji = '[Emj]',
    rg = '[Rg]',
  }
  local duplicates = {
    buffer = 1,
    path = 1,
    nvim_lsp = 0,
    luasnip = 1,
  }
  local duplicates_default = 0

  vim.o.completeopt = 'menu,menuone,noinsert,noselect'

  cmp.setup({
    completion = {
      keyword_length = 1,
    },
    experimental = {
      ghost_text = true,
    },
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        vim_item.kind = kind_icons[vim_item.kind]
        vim_item.menu = source_names[entry.source.name]
        vim_item.dup = duplicates[entry.source.name] or duplicates_default
        return vim_item
      end,
    },
    documentation = {
      border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'buffer' },
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'treesitter' },
      { name = 'luasnip' },
      { name = 'crates' },
      { name = 'rg' },
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    preselect = true,
    mapping = {
      ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable,
      ['<C-n>'] = cmp.config.disable,
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<Tab>'] = cmp.mapping.select_next_item({
        behavior = cmp.SelectBehavior.Insert,
      }, { 'i', 'c' }),
      ['<S-Tab>'] = cmp.mapping.select_prev_item({
        behavior = cmp.SelectBehavior.Insert,
      }, { 'i', 'c' }),
      ['<Esc>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
    },
  })

  -- FIXME
  vim.api.nvim_exec(
    [[au FileType sh lua require('cmp').setup.buffer{enabled=false}]],
    false
  )
end

return M
