local keymap = function(modes, left, right, options)
  options = vim.tbl_extend(
    'force',
    { noremap = true, silent = true },
    options or {}
  )
  vim.keymap.set(modes, left, right, options)
end

vim.g.mapleader = ','
vim.g.maplocalleader = ','
keymap('', '<leader>,', ',')

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

keymap('', '<C-n>', _G.tabnext)
keymap('', '<C-p>', _G.tabprev)

-- Reselect visual selection after indenting
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- Maintain the cursor position when yanking a visual selection
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
keymap('v', 'y', 'myy`y')
keymap('v', 'Y', 'myY`y')

-- Paste replace visual selection without copying it
keymap('v', '<leader>p', '"_dP')

-- Search for text in visual selection
keymap(
  'v',
  '*',
  '"zy/\\<\\V<C-r>=escape(@z, \'/\\\')<CR>\\><CR>',
  { silent = false }
)

-- Make Y behave like the other capitals
keymap('n', 'Y', 'y$')

vim.cmd([[
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
]])

-- escape from terminal
keymap('t', '<C-Esc>', '<C-\\><C-n>')

-- lsp
keymap('n', '<leader>cD', vim.lsp.buf.declaration)
keymap('n', '<leader>cd', vim.lsp.buf.definition)
keymap('n', 'K', vim.lsp.buf.hover)
keymap('n', '<leader>ci', vim.lsp.buf.implementation)
keymap('n', '<C-k>', vim.lsp.buf.signature_help)
keymap('n', '<leader>cwh', require('config.lsp').workspace_diagnostics)
keymap('n', '<leader>cwa', vim.lsp.buf.add_workspace_folder)
keymap('n', '<leader>cwr', vim.lsp.buf.remove_workspace_folder)
keymap('n', '<leader>cwl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end)
keymap('n', '<leader>ct', vim.lsp.buf.type_definition)
keymap('n', '<leader>cr', vim.lsp.buf.rename)
keymap('n', '<leader>ch', require('config.lsp').diagnostics)
keymap({ 'n', 'x' }, '<leader>ca', require('config.lsp').code_action)
keymap('v', '<leader>ca', require('config.lsp').range_code_action)
keymap('n', '<leader>cR', require('config.lsp').references)
keymap('n', '<leader>ce', vim.diagnostic.open_float)
keymap('n', '[c', vim.diagnostic.goto_prev)
keymap('n', ']c', vim.diagnostic.goto_next)

keymap('', '<space>e', require('config.tree').toggle)

keymap('n', '<leader>db', require('config.debug').toggle_breakpoint)
keymap('n', '<leader>dp', require('config.debug').step_back)
keymap('n', '<leader>di', require('config.debug').step_into)
keymap('n', '<leader>do', require('config.debug').step_out)
keymap('n', '<leader>dd', require('config.debug').step_over)

keymap('', '<space>d', require('config.debug').toggle)
