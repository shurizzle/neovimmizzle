local M = {}

function M.setup()
  local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
  if not null_ls_status_ok then
    return
  end

  local formatting = null_ls.builtins.formatting
  local sources = {}

  if executable('stylua') then
    table.insert(sources, formatting.stylua)
  end

  if executable('prettier') then
    table.insert(sources, formatting.prettier)
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
