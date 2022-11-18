function _G.cargo(args) term_run('cargo ' .. args) end

vim.api.nvim_command('command! -nargs=+ Cargo lua cargo(<q-args>)')
