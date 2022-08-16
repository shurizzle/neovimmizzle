return {
  settings = {
    ['rust-analyzer'] = {
      allFeatures = true,
      checkOnSave = {
        command = 'clippy',
      },
    },
  },
}
