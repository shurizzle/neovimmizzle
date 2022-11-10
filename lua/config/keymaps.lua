local K = vim.keymap.set

vim.g.mapleader = ','
vim.g.maplocalleader = ','

K('n', '<leader>,', ',', { noremap = true, silent = true })

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
    K(modes, left, right, options)
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

for k, v in pairs({
  ['<C-n>'] = { _G.tabnext, 'Go to next Tab' },
  ['<C-p>'] = { _G.tabprev, 'Go to previous Tab' },
}) do
  K('n', k, v[1], { silent = true, noremap = true, desc = v[2] })
end

for k, v in pairs({
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
  ['<leader>ca'] = {
    require('config.lsp').code_action,
    'Show available code actions',
  },
}) do
  K('v', k, v[1], { silent = true, noremap = true, desc = v[2] })
end

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
  ---@diagnostic disable-next-line
  choice = string.char(choice)
  ---@diagnostic disable-next-line
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

for k, v in pairs({
  -- Make Y behave like the other capitals
  Y = { 'y$', 'Yank untill the end of the line' },
  ['<leader>cD'] = { vim.lsp.buf.declaration, 'Show under-cursor declaration' },
  ['<leader>cd'] = { vim.lsp.buf.definition, 'Show under-cursor definition' },
  ['<leader>ci'] = {
    vim.lsp.buf.implementation,
    'Show under-cursor implementation',
  },
  ['<leader>cwh'] = {
    require('config.lsp').workspace_diagnostics,
    'Show workspace diagnostics',
  },
  ['<leader>cwa'] = { vim.lsp.buf.add_workspace_folder, 'Add workspace folder' },
  ['<leader>cwr'] = {
    vim.lsp.buf.remove_workspace_folder,
    'Remove workspace folder',
  },
  ['<leader>cwl'] = {
    function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    'List workspace folders',
  },
  ['<leader>ct'] = {
    vim.lsp.buf.type_definition,
    'Show under-cursor type definition',
  },
  ['<leader>cr'] = { vim.lsp.buf.rename, 'Rename under-cursor word' },
  ['<leader>ca'] = {
    require('config.lsp').code_action,
    'Show available code actions',
  },
  ['<leader>ch'] = {
    require('config.lsp').diagnostics,
    'Show buffer diagnostics',
  },
  ['<leader>cR'] = {
    require('config.lsp').references,
    'Show under-cursor references',
  },
  ['<leader>ce'] = {
    vim.diagnostic.open_float,
    'Show under-cursor diagnostics',
  },
  ['<leader>db'] = {
    require('config.debug').toggle_breakpoint,
    'Toggle breakpoint',
  },
  ['<leader>dp'] = { require('config.debug').step_back, 'Step back' },
  ['<leader>di'] = { require('config.debug').step_into, 'Step into' },
  ['<leader>do'] = { require('config.debug').step_out, 'Step out' },
  ['<leader>dd'] = { require('config.debug').step_over, 'Step over' },
  ['<leader>s'] = { switch_case, 'Switch case of under-cursor word' },
  K = { vim.lsp.buf.hover, 'Show under-cursor help' },
  ['[c'] = { vim.diagnostic.goto_prev, 'Go to previous diagnostic' },
  [']c'] = { vim.diagnostic.goto_next, 'Go to next diagnostic' },
  ['<space>d'] = { require('config.debug').toggle, 'Toggle dap-ui' },
  ['<space>e'] = {
    function()
      require('config.plugins.tree').toggle()
    end,
    'Toggle nvim-tree',
  },
  ZZ = { '<cmd>BufferClose<CR>', 'Close current buffer' },
  ZQ = { '<cmd>BufferClose!<CR>', 'Close current buffer without saving' },
  ['<C-h>'] = { '<cmd>wincmd h<CR>' },
  ['<C-j>'] = { '<cmd>wincmd j<CR>' },
  ['<C-k>'] = { '<cmd>wincmd k<CR>' },
  ['<C-l>'] = { '<cmd>wincmd l<CR>' },
}) do
  K('n', k, v[1], { silent = true, noremap = true, desc = v[2] })
end

for k, v in pairs({
  -- Make Y behave like the other capitals
  Y = { 'y$', 'Yank untill the end of the line' },
  ['<leader>ca'] = {
    require('config.lsp').code_action,
    'Show available code actions',
  },
}) do
  K('n', k, v[1], { silent = true, noremap = true, desc = v[2] })
end

for k, v in pairs({
  ['<leader>ca'] = {
    require('config.lsp').code_action,
    'Show available code actions',
  },
}) do
  K('x', k, v[1], { silent = true, noremap = true, desc = v[2] })
end
