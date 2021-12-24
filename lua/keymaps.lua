local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

keymap('', ',', '<Nop>', opts)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Just use vim.
local opts = { noremap = true, silent = true }
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

keymap('', '<C-n>', '<cmd>tabn<CR>', {})
keymap('', '<C-p>', '<cmd>tabp<CR>', {})

-- Reselect visual selection after indenting
keymap('v', '<', '<gv', { noremap = true })
keymap('v', '>', '>gv', { noremap = true })

-- Maintain the cursor position when yanking a visual selection
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
keymap('v', 'y', 'myy`y', { noremap = true })
keymap('v', 'Y', 'myY`y', { noremap = true })

-- Paste replace visual selection without copying it
keymap('v', '<leader>p', '"_dP', { noremap = true })

-- Make Y behave like the other capitals
keymap('n', 'Y', 'y$', { noremap = true })

vim.cmd([[
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
]])
