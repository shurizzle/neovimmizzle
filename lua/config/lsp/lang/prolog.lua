local _M = {}

local u = require('config.lsp.util')
local Job = require('plenary.job')
local Future = require('config.future')

local QUERY_CMD = { '--quiet', '-g', 'pack_list(lsp_server).', '-t', 'halt' }

local INSTALL_CMD = {
  '--quiet',
  '-g',
  'pack_install(lsp_server,[interactive(false),silent(true)]).',
  '-t',
  'halt',
}

local UPGRADE_CMD = {
  '--quiet',
  '-g',
  'pack_remove(lsp_server).',
  '-g',
  'pack_install(lsp_server,[interactive(false),silent(true)]).',
  '-t',
  'halt',
}

local function runcmd(args)
  local f = Future.new(function(resolve, reject)
    Job:new({
      command = 'swipl',
      args = args,
      on_exit = function(job, return_val)
        if return_val == 0 then
          resolve(job:result())
        else
          reject(
            'Command exited with error '
              .. return_val
              .. ':\n'
              .. table.concat(job:stderr_result(), '\n')
          )
        end
      end,
    }):start()
  end)

  f:catch(
    function(err)
      vim.notify(err, vim.log.levels.ERROR, {
        title = 'Swig',
      })
    end
  )

  return f
end

local function query()
  return runcmd(QUERY_CMD)
    :and_then(function(out)
      for _, line in ipairs(out) do
        line = vim.trim(line)
        if string.len(line) > 0 then
          local state, nv =
            unpack(vim.split(line, '%s+', { trimempty = true }), 1, 2)
          local name, version =
            unpack(vim.split(nv, '@', { plain = true, trimempty = true }), 1, 2)
          state = vim.trim(state)
          name = vim.trim(name)
          version = vim.trim(version)
          if name == 'lsp_server' then
            ---@type string|nil
            local new = version:match('%(([^()]+)%)')
            if new then new = vim.trim(new) end
            if not new or string.len(new) == 0 then
              new = nil
            else
              version = vim.trim(version:match('^[^()]+'))
            end
            if state == 'p' then
              new = version
              version = nil
            elseif state == 'A' then
              new = nil
            end

            return { name = name, version = version, new = new }
          end
        end
      end
    end)
    :and_then(function(v)
      if not v then
        local err = 'Package lsp_server not found'
        vim.notify(err, vim.log.levels.ERROR, { title = 'swipl' })
        return Future.rejected(err)
      else
        return Future.resolved(v)
      end
    end)
end

local function runinstall(pack)
  if pack.new and pack.version ~= pack.new then
    local okmsg = 'installed'
    local komsg = 'installation'

    return u.notify_progress(function(notify)
      local cmd = INSTALL_CMD
      local msg
      if pack.new and pack.version then
        okmsg = 'upgraded'
        komsg = 'upgrade'
        msg = 'lsp_server: upgrading to ' .. pack.new
        cmd = UPGRADE_CMD
      else
        msg = 'lsp_server: installing ' .. (pack.new or pack.version)
      end

      notify(msg, vim.log.levels.INFO, { title = 'swipl' })

      return runcmd(cmd)
    end, function(notify, ok)
      if ok then
        notify(
          'lsp_server: ' .. okmsg,
          vim.log.levels.INFO,
          { title = 'swipl' }
        )
      else
        notify(
          'lsp_server: ' .. komsg .. ' failed',
          vim.log.levels.ERROR,
          { title = 'swipl' }
        )
      end
    end)
  else
    return Future.resolved(nil)
  end
end

local cache = nil

local function install()
  if not cache then
    cache = query():and_then(function(x) return runinstall(x) end)
  end
  return cache
end

function _M.config()
  if not executable('swipl') then
    vim.notify(
      'Cannot find the executable',
      vim.log.levels.ERROR,
      { title = 'swipl' }
    )
    return
  end

  require('lspconfig.configs').prolog_lsp = {
    default_config = {
      cmd = {
        'swipl',
        '-g',
        'use_module(library(lsp_server)).',
        '-g',
        'lsp_server:main',
        '-t',
        'halt',
        '--',
        'stdio',
      },
      filetypes = { 'prolog' },
      root_dir = require('lspconfig.util').root_pattern('pack.pl'),
    },
    docs = {
      description = [[
  https://github.com/jamesnvc/prolog_lsp

  Prolog Language Server
        ]],
    },
  }

  return install():and_then(
    function() require('lspconfig').prolog_lsp.setup({}) end
  )
end

return _M
