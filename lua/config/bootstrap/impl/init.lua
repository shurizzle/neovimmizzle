if has('unix') then
  if vim.loop.os_uname().sysname:lower() == 'darwin' then
    return require('config.bootstrap.impl.macos')
  else
    return require('config.bootstrap.impl.unix')
  end
else
  return require('config.bootstrap.impl.windows')
end
