if vim.fn.getcwd() == base_dir() then
  return {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim', 'use' },
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.stdpath('config') .. '/lua'] = true,
          },
        },
      },
    },
  }
else
  return {}
end
