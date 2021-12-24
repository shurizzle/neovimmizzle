if has('terminal') then
  function _G.term_run(cmd)
    vim.api.nvim_command('terminal ' .. cmd)
  end
else
  function _G.term_run(cmd)
    vim.api.nvim_command('noautocmd new | terminal ' .. cmd)
  end
end
