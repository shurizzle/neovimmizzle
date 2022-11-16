local _M = {}

function _M.open()
  local ok, dapui, dapuiwin, state = pcall(require, 'dapui')
  if ok then
    dapui.open({})
  end
  ok, dapuiwin = pcall(require, 'dapui.windows')
  if not ok then
    return
  end
  ok, state = pcall(require, 'bufferline.api')
  if not ok then
    return
  end

  state.set_offset(dapuiwin.sidebar.area_state.size, 'Debugger')
end

function _M.close()
  local ok, dapui, state = pcall(require, 'dapui')
  if ok then
    dapui.close({})
  end
  ok, state = pcall(require, 'bufferline.api')
  if not ok then
    return
  end
  state.set_offset(0)
end

function _M.toggle()
  local ok, dapuiwin = pcall(require, 'dapui.windows')
  if not ok then
    return
  end

  if dapuiwin.sidebar:is_open() then
    _M.close()
  else
    _M.open()
  end
end

return _M
