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
