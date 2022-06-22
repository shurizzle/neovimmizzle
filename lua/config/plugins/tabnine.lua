local _M = {}

_M.run = has('win32') and 'powershell ./install.ps1' or './install.sh'

return _M
