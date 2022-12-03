local _M = {}

local Future = require('config.future')

function _M.packer_load(what)
  if not packer_plugins[what] or not packer_plugins[what].loaded then
    require('packer').loader(what)
  end
end

local function default_timeout()
  local ok, res = pcall(
    function() return require('notify')._config().default_timeout() end
  )

  return ok and res or 5000
end

function _M.notify_progress(init, finally)
  return Future.new(function(resolve, reject)
    vim.schedule(function()
      local id = nil
      local win = vim.api.nvim_get_current_win()

      local function notify_new(msg, log, opts)
        log = log or vim.log.levels.INFO
        opts = opts or {}
        opts.timeout = false

        id = vim.notify(msg, log, opts)
        return vim.deepcopy(id)
      end

      local function notify_edit(msg, log, opts)
        log = log or vim.log.levels.ERROR
        opts = opts or {}
        opts.replace = vim.deepcopy(id)
        opts.timeout = opts.timeout or default_timeout()

        local ok, res = pcall(
          vim.api.nvim_win_call,
          win,
          function() return vim.notify(msg, log, opts) end
        )
        if not ok then res = vim.notify(msg, log, opts) end

        return res
      end

      local future = init(notify_new)
      future:finally(function(...) finally(notify_edit, ...) end)
      future:and_then(resolve, reject)
    end)
  end)
end

return _M
