local _M = {}

function _M.config()
  require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    sync_install = is_headless(),
    ignore_install = { 'comment' }, -- List of parsers to ignore installing
    autopairs = {
      enable = true,
    },
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { '' }, -- list of language that will be disabled
      additional_vim_regex_highlighting = { 'org' },
    },
    indent = { enable = true, disable = { 'yaml' } },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  })

  vim.o.foldmethod = 'expr'
  vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost', 'FileType' }, {
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.schedule(function()
        vim.api.nvim_buf_call(bufnr, function() vim.cmd.normal('zR') end)
      end)
    end,
  })

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    vim.api.nvim_buf_call(bufnr, function() vim.cmd.normal('zR') end)
  end
end

return _M
