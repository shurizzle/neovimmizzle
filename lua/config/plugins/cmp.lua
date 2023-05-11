local _M = {}

_M.lazy = true

_M.dependencies = {
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-calc',
  'hrsh7th/cmp-emoji',
  'nvim-treesitter/nvim-treesitter',
  'ray-x/cmp-treesitter',
  'saadparwaiz1/cmp_luasnip',
  'L3MON4D3/LuaSnip',
  'ahmedkhalf/project.nvim',
}

_M.event = 'InsertEnter'

local function has_words_before()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match('%s')
      == nil
end

function _M.config()
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  local kind_icons = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = '',
    Variable = '',
    Class = '',
    Interface = '',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    Event = '',
    Operator = '',
    TypeParameter = '',
  }
  local source_names = {
    nvim_lsp = '[Lsp]',
    treesitter = '[Tre]',
    luasnip = '[Snp]',
    buffer = '[Buf]',
    nvim_lua = '[Lua]',
    path = '[Pat]',
    calc = '[Clc]',
    emoji = '[Emj]',
    rg1 = '[Rg]',
    orgmode = '[Org]',
    crates = '[Crg]',
  }
  local duplicates = {
    buffer = 1,
    path = 1,
    nvim_lsp = nil,
    luasnip = 1,
  }
  local duplicates_default = nil

  vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

  cmp.setup({
    completion = {
      keyword_length = 1,
    },
    experimental = {
      native_menu = false,
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
    window = {
      documentation = {
        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
      },
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'treesitter' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'orgmode' },
    },
    snippet = {
      expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    preselect = 'None',
    mapping = {
      ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable,
      ['<C-n>'] = cmp.config.disable,
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete({}), { 'i', 'c' }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<Esc>'] = { c = cmp.mapping.abort() },
      ['<CR>'] = cmp.mapping({
        i = function(fallback)
          if cmp.visible() then
            if cmp.get_selected_entry() then
              cmp.confirm()
            else
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
              })
            end
          else
            fallback()
          end
        end,
        s = cmp.mapping.confirm({ select = true }),
        c = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      }),
    },
  })
end

return _M
