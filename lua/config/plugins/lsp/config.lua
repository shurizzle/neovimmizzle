local _M = {}

function _M.config()
  local lsputil = require('lspconfig.util')

  lsputil.on_setup = lsputil.add_hook_before(
    lsputil.on_setup,
    function(cfg)
      cfg.capabilities = vim.tbl_deep_extend(
        'force',
        require('cmp_nvim_lsp').default_capabilities(),
        cfg.capabilities or {}
      )
    end
  )
end

return _M
