local _M = {}

_M.module_pattern = {
  '^lspconfig$',
  '^lspconfig%.',
}

function _M.config()
  local lsputil = require('lspconfig.util')

  lsputil.on_setup = lsputil.add_hook_before(lsputil.on_setup, function(cfg)
    local function on_attach(client, bufnr)
      require('lsp_signature').on_attach({
        floating_window_above_cur_line = true,
        floating_window = true,
        transparency = 10,
      }, bufnr)
    end

    if cfg.on_attach then
      cfg.on_attach = (function(old)
        return function(client, bufnr)
          old(client, bufnr)
          on_attach(client, bufnr)
        end
      end)(cfg.on_attach)
    else
      cfg.on_attach = on_attach
    end

    cfg.capabilities = vim.tbl_deep_extend(
      'force',
      require('cmp_nvim_lsp').default_capabilities(),
      cfg.capabilities or {}
    )
  end)

  require('packer.load')(
    { 'nlsp-settings.nvim' },
    { module = 'nvim-lspconfig' },
    packer_plugins
  )
end

return _M
