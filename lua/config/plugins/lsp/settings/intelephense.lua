local storage_path = join_paths(vim.fn.expand('~'), '.intelephense')

return {
  init_options = {
    globalStoragePath = storage_path,
  },
}
