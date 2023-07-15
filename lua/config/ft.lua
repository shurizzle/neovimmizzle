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

vim.filetype.add({
  extension = {
    vert = 'glsl',
    tesc = 'glsl',
    tese = 'glsl',
    glsl = 'glsl',
    geom = 'glsl',
    frag = 'glsl',
    comp = 'glsl',
    rgen = 'glsl',
    rint = 'glsl',
    rchit = 'glsl',
    rahit = 'glsl',
    rmiss = 'glsl',
    rcall = 'glsl',
  },
})
