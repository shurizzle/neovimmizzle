vim.filetype.add({
  filename = {
    ['pezzo.conf'] = 'pezzo',
    ['pezzo.d/*.conf'] = 'pezzo',
  },
})

vim.filetype.add({
  extension = {
    nu = 'nu',
  },
})
