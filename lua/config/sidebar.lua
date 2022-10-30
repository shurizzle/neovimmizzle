local _M = {}

local resize_callbacks = {}
local close_callbacks = {}
local name = nil
local closefn = nil

local function resize(width)
  vim.validate({
    width = { width, 'n' },
  })
  vim.schedule(function()
    for _, cb in ipairs(resize_callbacks) do
      cb(width)
    end
  end)
end

local function raw_close()
  name = nil
  closefn = nil
  for _, cb in ipairs(close_callbacks) do
    cb()
  end
end

local function close()
  vim.schedule(function()
    raw_close()
  end)
end

function _M.get_name()
  return name
end

function _M.on_resize(cb)
  vim.validate({
    cb = { cb, 'f' },
  })

  table.insert(resize_callbacks, cb)
end

function _M.on_close(cb)
  vim.validate({
    cb = { cb, 'f' },
  })

  table.insert(close_callbacks, cb)
end

function _M.close(cb)
  vim.validate({
    cb = { cb, 'f' },
  })

  local on_close = function()
    vim.schedule(function()
      raw_close()
      cb()
    end)
  end

  if closefn then
    closefn(on_close)
  else
    on_close()
  end
end

function _M.register(widget_name, close_function, cb)
  vim.validate({
    widget_name = { widget_name, 's' },
    close_function = { close_function, 'f' },
    cb = { cb, 'f' },
  })

  _M.close(function()
    name = widget_name
    closefn = close_function
    cb({
      resize = resize,
      close = close,
    })
  end)
end

return _M
