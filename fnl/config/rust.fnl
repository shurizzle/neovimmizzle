(fn _G.cargo [args] (term-run (.. "cargo " args)))

(vim.api.nvim_command "command! -nargs=+ Cargo lua cargo(<q-args>)")
