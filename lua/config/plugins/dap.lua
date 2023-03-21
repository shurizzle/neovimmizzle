local _M = {}

_M.lazy = true

_M.keys = {
  { mode = 'n', '<leader>db' },
  { mode = 'n', '<leader>dp' },
  { mode = 'n', '<leader>di' },
  { mode = 'n', '<leader>do' },
  { mode = 'n', '<leader>dd' },
}

function _M.config()
  local dap = require('dap')

  for k, v in pairs({
    ['<leader>db'] = {
      dap.toggle_breakpoint,
      'Toggle breakpoint',
    },
    ['<leader>dp'] = { dap.step_back, 'Step back' },
    ['<leader>di'] = { dap.step_into, 'Step into' },
    ['<leader>do'] = { dap.step_out, 'Step out' },
    ['<leader>dd'] = { dap.step_over, 'Step over' },
  }) do
    vim.keymap.set('n', k, v[1], { silent = true, noremap = true, desc = v[2] })
  end
  --
end

return _M
