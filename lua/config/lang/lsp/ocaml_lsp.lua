local Future = require('config.future')

return Future.join({
  require('config.lang.installer')['ocaml-lsp'],
  require('config.lang.installer')['ocamlformat'],
}):and_then(function(res)
  if res[1][1] then
    require('lspconfig').ocamllsp.setup({})
    return Future.resolved(nil)
  else
    return Future.rejected(res[1][2])
  end
end)
