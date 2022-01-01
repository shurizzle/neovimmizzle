local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

keymap('', ',', '<Nop>', opts)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Just use vim.
opts = { silent = true }
for name, key in pairs({
  'Left',
  'Right',
  'Up',
  'Down',
  'PageUp',
  'PageDown',
  'End',
  'Home',
  Backspace = 'BS',
  Delete = 'Del',
}) do
  if type(name) == 'number' then
    name = key
  end

  keymap(
    'n',
    '<' .. key .. '>',
    '<cmd>echo "No ' .. name .. ' for you!"<CR>',
    opts
  )
  keymap(
    'v',
    '<' .. key .. '>',
    '<cmd><C-u>echo "No ' .. name .. ' for you!"<CR>',
    opts
  )
  keymap(
    'i',
    '<' .. key .. '>',
    '<C-o><cmd>echo "No ' .. name .. ' for you!"<CR>',
    opts
  )
end

opts = { noremap = true, silent = true }

keymap('', '<C-n>', '<cmd>lua tabnext()<CR>', {})
keymap('', '<C-p>', '<cmd>lua tabprev()<CR>', {})

-- Reselect visual selection after indenting
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Maintain the cursor position when yanking a visual selection
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
keymap('v', 'y', 'myy`y', opts)
keymap('v', 'Y', 'myY`y', opts)

-- Paste replace visual selection without copying it
keymap('v', '<leader>p', '"_dP', opts)

-- Make Y behave like the other capitals
keymap('n', 'Y', 'y$', opts)

vim.cmd([[
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
]])

-- lsp
keymap('n', '<leader>cD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
keymap('n', '<leader>cd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
keymap('n', '<leader>ci', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
keymap(
  'n',
  '<leader>cwa',
  '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
  opts
)
keymap(
  'n',
  '<leader>cwr',
  '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
  opts
)
keymap(
  'n',
  '<leader>cwl',
  '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
  opts
)
keymap(
  'n',
  '<leader>ct',
  '<cmd>tab lua vim.lsp.buf.type_definition()<CR>',
  opts
)
keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
keymap(
  'n',
  '<leader>ch',
  '<cmd>lua require"config.lsp".diagnostics()<CR>',
  opts
)
keymap(
  'n',
  '<leader>ca',
  '<cmd>lua require"config.lsp".code_action()<CR>',
  opts
)
keymap(
  'x',
  '<leader>ca',
  '<cmd>lua require"config.lsp".code_action()<CR>',
  opts
)
keymap('n', '<leader>cR', '<cmd>lua require"config.lsp".references()<CR>', opts)
keymap('n', '<leader>ce', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
keymap('n', '[c', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
keymap('n', ']c', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

keymap('', '<space>e', '<cmd>lua require"config.tree".toggle()<CR>', opts)

keymap(
  'n',
  '<leader>db',
  '<cmd>lua require"config.debug".toggle_breakpoint()<CR>',
  opts
)
keymap(
  'n',
  '<leader>dp',
  '<cmd>lua require"config.debug".step_back()<CR>',
  opts
)
keymap(
  'n',
  '<leader>di',
  '<cmd>lua require"config.debug".step_into()<CR>',
  opts
)
keymap('n', '<leader>do', '<cmd>lua require"config.debug".step_out()<CR>', opts)
keymap(
  'n',
  '<leader>dd',
  '<cmd>lua require"config.debug".step_over()<CR>',
  opts
)

keymap('', '<space>d', '<cmd>lua require"config.debug".toggle()<CR>', opts)
