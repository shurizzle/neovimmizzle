local _M = {}

_M.module_pattern = {
  '^dap$',
  '^dap%.',
}

_M.keys = {
  { 'n', '<leader>db' },
  { 'n', '<leader>dp' },
  { 'n', '<leader>di' },
  { 'n', '<leader>do' },
  { 'n', '<leader>dd' },
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
