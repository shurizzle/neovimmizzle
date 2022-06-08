local _M = {}

vim.cmd('command! Format lua vim.lsp.buf.formatting()')
vim.api.nvim_exec(
  [[
augroup lsp_document
  autocmd!
  autocmd CursorHold * lua vim.diagnostic.open_float()
  autocmd CursorMoved * lua vim.lsp.buf.clear_references()
  autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
augroup END
]],
  false
)

local function action_severity(action)
  if not action.diagnostics then
    return 0
  end

  local s = 0
  for _, value in ipairs(action.diagnostics) do
    if value.serverity and value.serverity > s then
      s = value.serverity
    end
  end
  return s
end

local function sort_actions(a, b)
  return action_severity(a) <= action_severity(b)
end

function _M.diagnostics()
  if vim.fn.exists(':Telescope') ~= 0 then
    vim.cmd('Telescope diagnostics bufnr=0 theme=get_dropdown')
  end
end

function _M.code_action()
  vim.lsp.buf.code_action({ sort = sort_actions })
end

function _M.range_code_action()
  vim.lsp.buf.range_code_action({ sort = sort_actions })
end

function _M.references()
  if vim.fn.exists(':Telescope') ~= 0 then
    vim.cmd('Telescope lsp_references theme=get_dropdown')
  else
    vim.lsp.buf.references()
  end
end

---@private
--
--- This is not public because the main extension point is
--- vim.ui.select which can be overridden independently.
---
--- Can't call/use vim.lsp.handlers['textDocument/codeAction'] because it expects
--- `(err, CodeAction[] | Command[], ctx)`, but we want to aggregate the results
--- from multiple clients to have 1 single UI prompt for the user, yet we still
--- need to be able to link a `CodeAction|Command` to the right client for
--- `codeAction/resolve`
local function on_code_action_results(results, ctx, options)
  local action_tuples = {}

  ---@private
  local function action_filter(a)
    -- filter by specified action kind
    if options and options.context and options.context.only then
      if not a.kind then
        return false
      end
      local found = false
      for _, o in ipairs(options.context.only) do
        -- action kinds are hierachical with . as a separator: when requesting only
        -- 'quickfix' this filter allows both 'quickfix' and 'quickfix.foo', for example
        if a.kind:find('^' .. o .. '$') or a.kind:find('^' .. o .. '%.') then
          found = true
          break
        end
      end
      if not found then
        return false
      end
    end
    -- filter by user function
    if options and options.filter and not options.filter(a) then
      return false
    end
    -- no filter removed this action
    return true
  end

  for client_id, result in pairs(results) do
    for _, action in pairs(result.result or {}) do
      if action_filter(action) then
        table.insert(action_tuples, { client_id, action })
      end
    end
  end

  if #action_tuples ~= 0 and options and options.sort then
    table.sort(action_tuples, function(a, b)
      return options.sort(a[2], b[2])
    end)
  end

  if #action_tuples == 0 then
    vim.notify('No code actions available', vim.log.levels.INFO)
    return
  end

  ---@private
  local function apply_action(action, client)
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
    if action.command then
      local command = type(action.command) == 'table' and action.command
        or action
      local fn = client.commands[command.command]
        or vim.lsp.commands[command.command]
      if fn then
        local enriched_ctx = vim.deepcopy(ctx)
        enriched_ctx.client_id = client.id
        fn(command, enriched_ctx)
      else
        -- Not using command directly to exclude extra properties,
        -- see https://github.com/python-lsp/python-lsp-server/issues/146
        local params = {
          command = command.command,
          arguments = command.arguments,
          workDoneToken = command.workDoneToken,
        }
        client.request('workspace/executeCommand', params, nil, ctx.bufnr)
      end
    end
  end

  ---@private
  local function on_user_choice(action_tuple)
    if not action_tuple then
      return
    end
    -- textDocument/codeAction can return either Command[] or CodeAction[]
    --
    -- CodeAction
    --  ...
    --  edit?: WorkspaceEdit    -- <- must be applied before command
    --  command?: Command
    --
    -- Command:
    --  title: string
    --  command: string
    --  arguments?: any[]
    --
    local client = vim.lsp.get_client_by_id(action_tuple[1])
    local action = action_tuple[2]
    if
      not action.edit
      and client
      and vim.tbl_get(
        client.server_capabilities,
        'codeActionProvider',
        'resolveProvider'
      )
    then
      client.request(
        'codeAction/resolve',
        action,
        function(err, resolved_action)
          if err then
            vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
            return
          end
          apply_action(resolved_action, client)
        end
      )
    else
      apply_action(action, client)
    end
  end

  -- If options.apply is given, and there are just one remaining code action,
  -- apply it directly without querying the user.
  if options and options.apply and #action_tuples == 1 then
    on_user_choice(action_tuples[1])
    return
  end

  vim.ui.select(action_tuples, {
    prompt = 'Code actions:',
    kind = 'codeaction',
    format_item = function(action_tuple)
      local title = action_tuple[2].title:gsub('\r\n', '\\r\\n')
      return title:gsub('\n', '\\n')
    end,
  }, on_user_choice)
end

--- Requests code actions from all clients and calls the handler exactly once
--- with all aggregated results
---@private
local function code_action_request(params, options)
  local bufnr = vim.api.nvim_get_current_buf()
  local method = 'textDocument/codeAction'
  vim.lsp.buf_request_all(bufnr, method, params, function(results)
    local ctx = { bufnr = bufnr, method = method, params = params }
    on_code_action_results(results, ctx, options)
  end)
end

--- Selects a code action available at the current
--- cursor position.
---
---@param options table|nil Optional table which holds the following optional fields:
---    - context (table|nil):
---        Corresponds to `CodeActionContext` of the LSP specification:
---          - diagnostics (table|nil):
---                        LSP `Diagnostic[]`. Inferred from the current
---                        position if not provided.
---          - only (table|nil):
---                 List of LSP `CodeActionKind`s used to filter the code actions.
---                 Most language servers support values like `refactor`
---                 or `quickfix`.
---    - filter (function|nil):
---             Predicate function taking an `CodeAction` and returning a boolean.
---    - apply (boolean|nil):
---             When set to `true`, and there is just one remaining action
---            (after filtering), the action is applied without user query.
---@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_codeAction
vim.lsp.buf.code_action = function(options)
  vim.validate({ options = { options, 't', true } })
  options = options or {}
  -- Detect old API call code_action(context) which should now be
  -- code_action({ context = context} )
  if options.diagnostics or options.only then
    options = { options = options }
  end
  local context = options.context or {}
  if not context.diagnostics then
    local bufnr = vim.api.nvim_get_current_buf()
    context.diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr)
  end
  local params = vim.lsp.util.make_range_params()
  params.context = context
  code_action_request(params, options)
end

return _M
