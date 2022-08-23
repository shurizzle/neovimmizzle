local keymap = require('which-key')

vim.g.mapleader = ','
vim.g.maplocalleader = ','

keymap.register({
  [','] = { ',', '' },
}, {
  prefix = '<leader>',
})

-- Just use vim.
for name, key in pairs({
  'Left',
  'Right',
  'Up',
  'Down',
  'PageUp',
  'PageDown',
  'End',
  'Home',
  Delete = 'Del',
}) do
  if type(name) == 'number' then
    name = key
  end

  local keymap = function(modes, left, right, options)
    options =
      vim.tbl_extend('force', { noremap = true, silent = true }, options or {})
    vim.keymap.set(modes, left, right, options)
  end

  keymap(
    'n',
    '<' .. key .. '>',
    '<cmd>echo "No ' .. name .. ' for you!"<CR>',
    { noremap = false }
  )
  keymap(
    'v',
    '<' .. key .. '>',
    '<cmd><C-u>echo "No ' .. name .. ' for you!"<CR>',
    { noremap = false }
  )
  keymap(
    'i',
    '<' .. key .. '>',
    '<C-o><cmd>echo "No ' .. name .. ' for you!"<CR>',
    { noremap = false }
  )
end

keymap.register({
  ['<C-n>'] = { _G.tabnext, 'Go to next tab' },
  ['<C-p>'] = { _G.tabprev, 'Go to previous tab' },
})

keymap.register({
  -- Reselect visual selection after indenting
  ['<'] = { '<gv', 'Indent back' },
  ['>'] = { '>gv', 'Indent' },
  -- Maintain the cursor position when yanking a visual selection
  -- http://ddrscott.github.io/blog/2016/yank-without-jank/
  ['y'] = { 'myy`y', 'yank text' },
  ['Y'] = { 'myY`y', 'yank text until the end of the line' },
  -- Paste replace visual selection without copying it
  ['<leader>p'] = { '"_dP', 'Replace visual selection' },
  -- Search for text in visual selection
  ['*'] = {
    '"zy/\\<\\V<C-r>=escape(@z, \'/\\\')<CR>\\><CR>',
    'Search for selected text',
  },
}, {
  mode = 'v',
})

keymap.register({
  -- Make Y behave like the other capitals
  Y = { 'y$', 'Yank untill the end of the line' },
}, { mode = 'n' })

vim.cmd([[
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
]])

local function switch_case()
  vim.api.nvim_echo(
    { { ' [u]pper [s]nake [k]ebab [p]ascal [c]amel', 'Normal' } },
    false,
    {}
  )
  local map = {
    u = 'upper',
    s = 'snake',
    k = 'kebab',
    p = 'pascal',
    c = 'camel',
  }
  local choice = vim.fn.getchar()
  vim.api.nvim_echo({ { '', 'Normal' } }, false, {})
  if choice == 27 then
    return
  end
  choice = string.char(choice)
  choice = map[choice]
  if choice then
    vim.fn.feedkeys(
      'ciw'
        .. string.char(18)
        .. '=v:lua.convertcase(\''
        .. choice
        .. '\', getreg(\'"\'))'
        .. string.char(10)
        .. string.char(27)
    )
  else
    vim.api.nvim_echo({ { 'Invalid choice', 'Error' } }, false, {})
  end
end

keymap.register({
  ['<leader>'] = {
    c = {
      D = { vim.lsp.buf.declaration, 'Show under-cursor declaration' },
      d = { vim.lsp.buf.definition, 'Show under-cursor definition' },
      i = { vim.lsp.buf.implementation, 'Show under-cursor implementation' },
      w = {
        h = {
          require('config.lsp').workspace_diagnostics,
          'Show workspace diagnostics',
        },
        a = { vim.lsp.buf.add_workspace_folder, 'Add workspace folder' },
        r = { vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder' },
        l = {
          function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end,
          'List workspace folders',
        },
      },
      t = { vim.lsp.buf.type_definition, 'Show under-cursor type definition' },
      r = { vim.lsp.buf.rename, 'Rename under-cursor word' },
      a = { require('config.lsp').code_action, 'Show available code actions' },
      R = { require('config.lsp').references, 'Show under-cursor references' },
      e = { vim.diagnostic.open_float, 'Show under-cursor diagnostics' },
    },
    d = {
      b = { require('config.debug').toggle_breakpoint, 'Toggle breakpoint' },
      p = { require('config.debug').step_back, 'Step back' },
      i = { require('config.debug').step_into, 'Step into' },
      o = { require('config.debug').step_out, 'Step out' },
      d = { require('config.debug').step_over, 'Step over' },
    },
    s = { switch_case, 'Switch case of under-cursor word' },
  },
  K = { vim.lsp.buf.hover, 'Show under-cursor help' },
  ['<C-k>'] = {
    vim.lsp.buf.signature_help,
    'Show under-cursor signature help',
  },
  ['[c'] = { vim.diagnostic.goto_prev, 'Go to previous diagnostic' },
  [']c'] = { vim.diagnostic.goto_next, 'Go to next diagnostic' },
  ['<space>e'] = { require('config.tree').toggle, 'Toggle nvim-tree' },
  ['<space>d'] = { require('config.debug').toggle, 'Toggle dap-ui' },
  ZZ = { '<cmd>BufferClose<CR>', 'Close current buffer' },
}, { mode = 'n' })

keymap.register({
  ['<leader>'] = {
    c = {
      a = { require('config.lsp').code_action, 'Show available code actions' },
    },
  },
}, { mode = 'x' })

keymap.register({
  ['<leader>'] = {
    c = {
      a = {
        require('config.lsp').range_code_action,
        'Show available code actions',
      },
    },
  },
}, { mode = 'v' })
