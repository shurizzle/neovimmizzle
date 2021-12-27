local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

keymap('', ',', '<Nop>', opts)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Just use vim.
opts = { noremap = true, silent = true }
for _, key in pairs({ 'Left', 'Right', 'Up', 'Down', 'PageUp', 'PageDown', 'End', 'Home' }) do
  keymap(
    'n',
    '<' .. key .. '>',
    '<cmd>echo "No ' .. key .. ' for you!"<CR>',
    opts
  )
  keymap(
    'v',
    '<' .. key .. '>',
    '<cmd><C-u>echo "No ' .. key .. ' for you!"<CR>',
    opts
  )
  keymap(
    'i',
    '<' .. key .. '>',
    '<C-o><cmd>echo "No ' .. key .. ' for you!"<CR>',
    opts
  )
end

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
keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
keymap('n', 'tgD', '<cmd>tab lua vim.lsp.buf.declaration()<CR>', opts)
keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
keymap('n', 'tgd', '<cmd>tab lua vim.lsp.buf.definition()<CR>', opts)
keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
keymap('n', 'tgi', '<cmd>tab lua vim.lsp.buf.implementation()<CR>', opts)
keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
keymap(
  'n',
  '<leader>wa',
  '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
  opts
)
keymap(
  'n',
  '<leader>wr',
  '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
  opts
)
keymap(
  'n',
  '<leader>wl',
  '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
  opts
)
keymap(
  'n',
  '<leader>tD',
  '<cmd>tab lua vim.lsp.buf.type_definition()<CR>',
  opts
)
keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
keymap('n', '<leader>a', '<cmd>lua require"lsp".diagnostics()<CR>', opts)
keymap('n', '<leader>ca', '<cmd>lua require"lsp".code_action()<CR>', opts)
keymap('x', '<leader>ca', '<cmd>lua require"lsp".code_action()<CR>', opts)
keymap('n', 'gr', '<cmd>lua require"lsp".references()<CR>', opts)
keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
keymap('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
keymap('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

keymap('', '<space>e', '<cmd>lua require"tree".toggle()<CR>', opts)
