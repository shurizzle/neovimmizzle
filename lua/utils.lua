if has('terminal') then
  function _G.term_run(cmd)
    vim.api.nvim_command('terminal ' .. cmd)
  end
else
  function _G.term_run(cmd)
    vim.api.nvim_command('noautocmd new | terminal ' .. cmd)
  end
end

function _G.colorscheme(...)
  local names = { ... }
  if #names == 0 then
    return vim.api.nvim_exec('colo', true)
  elseif #names == 1 then
    names = names[1]
  end

  if type(names) == 'string' then
    return vim.api.nvim_exec(
      'try | colo ' .. names .. ' | catch /E185/ | echo \'fail\' | endtry',
      true
    ) ~= 'fail'
  else
    for _, name in pairs(names) do
      if colorscheme(name) then
        return true
      end
    end
    return false
  end
end

function _G.tabnext()
  if vim.fn.exists(':BufferNext') ~= 0 then
    vim.api.nvim_command('BufferNext')
  else
    vim.api.nvim_command('tabn')
  end
end

function _G.tabprev()
  if vim.fn.exists(':BufferPrevious') ~= 0 then
    vim.api.nvim_command('BufferPrevious')
  else
    vim.api.nvim_command('tabp')
  end
end
