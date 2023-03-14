local _M = {}

function _M.cond() return require('config.platform').is.ssh end

function _M.config()
  require('osc52').setup({
    max_length = 0,
    silent = false,
    trim = false,
  })

  local function copy(lines, _) require('osc52').copy(table.concat(lines, '\n')) end

  local function paste()
    local lines = {}
    for line in vim.gsplit(vim.fn.getreg(''), '\n', true) do
      table.insert(lines, line)
    end
    return { lines, vim.fn.getregtype('') }
  end

  vim.g.clipboard = {
    name = 'osc52',
    copy = { ['+'] = copy, ['*'] = copy },
    paste = { ['+'] = paste, ['*'] = paste },
  }
end

return _M
