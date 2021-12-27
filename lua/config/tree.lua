local M = {}

function M.open()
  local ok, tree = pcall(require, 'nvim-tree')
  if not ok then
    return
  end
  tree.find_file(true)
  if not M.is_open() then
    tree.open()
  end
  local view, state
  ok, view = pcall(require, 'nvim-tree.view')
  if not ok then
    return
  end
  local width = view.View.width
  ok, state = pcall(require, 'bufferline.state')
  if not ok then
    return
  end
  state.set_offset(width + 1, 'Explorer')
end

function M.close()
  local ok, tree = pcall(require, 'nvim-tree')
  if not ok then
    return
  end
  tree.close()
  local state
  ok, state = pcall(require, 'bufferline.state')
  if not ok then
    return
  end
  state.set_offset(0)
end

function M.is_open()
  local ok, view = pcall(require, 'nvim-tree.view')
  if not ok then
    return
  end
  return view.win_open()
end

function M.toggle()
  return M[M.is_open() and 'close' or 'open']()
end

return M
