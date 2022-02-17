local M = {}

function M.config()
  local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
  if not null_ls_status_ok then
    return
  end

  local diagnostics, code_actions, formatting =
    null_ls.builtins.diagnostics,
    null_ls.builtins.code_actions,
    null_ls.builtins.formatting
  local sources = {}

  if executable('stylua') then
    table.insert(sources, formatting.stylua)
  end

  if executable('eslint_d') then
    table.insert(sources, diagnostics.eslint_d)
    table.insert(sources, code_actions.eslint_d)
    table.insert(sources, formatting.eslint_d)
  elseif executable('eslint') then
    table.insert(sources, diagnostics.eslint)
    table.insert(sources, code_actions.eslint)
    table.insert(sources, formatting.eslint)
  elseif executable('prettier') then
    table.insert(sources, formatting.prettier)
  end

  if executable('blade-formatter') then
    local bladeformatter = {
      name = 'bladeformatter',
      method = null_ls.methods.FORMATTING,
      filetypes = { 'blade' },
      generator = null_ls.formatter({
        command = 'blade-formatter',
        args = {
          '--stdin',
        },
        to_stdin = true,
        format = 'raw',
      }),
    }
    table.insert(sources, bladeformatter)
  end

  if executable('php-cs-fixer') then
    table.insert(
      sources,
      formatting.phpcsfixer.with({
        extra_args = { '--rules=@PSR12,no_unused_imports' },
      })
    )
  end

  null_ls.setup({
    debug = false,
    sources = sources,
  })
end

return M
