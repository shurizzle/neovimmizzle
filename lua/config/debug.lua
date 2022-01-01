local M = {}

function M.open()
  local ok, dapui, dapuiwin, state = pcall(require, 'dapui')
  if ok then
    require('config.tree').close()
    dapui.open()
  end
  ok, dapuiwin = pcall(require, 'dapui.windows')
  if not ok then
    return
  end
  ok, state = pcall(require, 'bufferline.state')
  if not ok then
    return
  end

  state.set_offset(dapuiwin.sidebar.area_state.size, 'Debugger')
end

function M.close()
  local ok, dapui, state = pcall(require, 'dapui')
  if ok then
    dapui.close()
  end
  ok, state = pcall(require, 'bufferline.state')
  if not ok then
    return
  end
  state.set_offset(0)
end

function M.toggle()
  local ok, dapuiwin = pcall(require, 'dapui.windows')
  if not ok then
    return
  end

  if dapuiwin.sidebar:is_open() then
    M.close()
  else
    M.open()
  end
end

function M.toggle_breakpoint()
  local ok, dap = pcall(require, 'dap')
  if ok then
    dap.toggle_breakpoint()
  end
end

function M.step_back()
  local ok, dap = pcall(require, 'dap')
  if ok then
    dap.toggle_breakpoint()
  end
end

function M.step_into()
  local ok, dap = pcall(require, 'dap')
  if ok then
    dap.step_into()
  end
end

function M.step_out()
  local ok, dap = pcall(require, 'dap')
  if ok then
    dap.step_out()
  end
end

function M.step_over()
  local ok, dap = pcall(require, 'dap')
  if ok then
    dap.step_over()
  end
end

function M.continue()
  local ok, dap = pcall(require, 'dap')
  if ok then
    dap.continue()
  end
end

return M
