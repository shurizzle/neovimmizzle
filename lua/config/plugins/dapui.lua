local M = {}

function M.config()
  local dap, dapui, debug =
    require('dap'), require('dapui'), require('config.debug')

  dapui.setup()

  dap.listeners.after.event_initialized['dapui_config'] = function()
    debug.open()
  end

  dap.listeners.after.event_terminated['dapui_config'] = function()
    debug.close()
  end

  dap.listeners.after.event_exited['dapui_config'] = function()
    debug.close()
  end
end

return M
