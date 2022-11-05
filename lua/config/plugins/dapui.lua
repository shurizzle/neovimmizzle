local M = {}

function M.config()
  -- TODO: configure with sidebar
  local dap, dapui = require('dap'), require('dapui')

  dapui.setup()

  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open({})
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close({})
    dap.repl.close()
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close({})
    dap.repl.close()
  end
end

return M
