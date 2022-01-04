local _M = {}

-- local install_brew_cmd =
--   '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
local install_brew_cmd = 'echo ciao'

local binmap = {
  ['git'] = 'git',
  ['gcc'] = 'xcode',
  ['make'] = 'xcode',
  ['fd'] = 'fd',
  ['rg'] = 'ripgrep',
  ['curl'] = nil, -- Already installed in MacOSX
}

function _M.map_bin(bin)
  return binmap[bin]
end

local function create_window()
  vim.cmd('botright split')
  return vim.api.nvim_get_current_win()
end

local function create_buffer()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].buflisted = false
  vim.bo[bufnr].modifiable = false
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd('setl filetype=')
  end)
end

local function destroy_terminal(winnr, bufnr)
  vim.api.nvim_win_close(winnr, { force = true })
  vim.api.nvim_buf_delete(bufnr, { force = true })
end

local function termopen(cmd, opts)
  local winnr = create_window()
  local bufnr = create_buffer()
  vim.api.nvim_win_set_buf(winnr, bufnr)

  local on_exit = opts.on_exit
  if on_exit then
    opts.on_exit = function(...)
      pcall(destroy_terminal, winnr, bufnr)
      on_exit(...)
    end
  else
    opts.on_exit = function()
      pcall(destroy_terminal, winnr, bufnr)
    end
  end

  local jobid = vim.fn.termopen(cmd, opts)
  if not jobid or jobid < 1 then
    pcall(destroy_terminal, winnr, bufnr)
  end

  return jobid
end

local function install_brew(cb)
  local _cb = vim.is_callable(cb) and cb or function() end

  vim.notify('Installing brew, a shell will open')

  local jobid = termopen(install_brew_cmd, {
    detach = 1,
    on_exit = function(_, exit_code)
      vim.notify('CULO')
      if exit_code == 0 then
        _cb(true)
      else
        _cb(false, 'Error while installing brew')
      end
    end,
  })

  if jobid < 1 then
    _cb(false)
  end
end

function _M.install_packages(packages, cb)
  local _cb = vim.is_callable(cb) and cb or function() end
  -- _cb(true)

  install_brew(_cb)
end

return _M
