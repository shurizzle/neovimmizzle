local _M = {}

_M.module_pattern = {
  '^lspconfig$',
  '^lspconfig%.',
}

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

  require('packer.load')(
    { 'nlsp-settings.nvim' },
    { module = 'nvim-lspconfig' },
    packer_plugins
  )
end

return _M
