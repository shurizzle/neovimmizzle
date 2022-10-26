local _M = {}

function _M.packer_load(what)
  if not packer_plugins[what] or not packer_plugins[what].loaded then
    require('packer').loader(what)
  end
end

return _M
