local _M = {}

local function arrow(where)
  return string.format(':lua require\'config.plugins.tree\'.on_%s()<CR>', where)
end

function _M.on_left()
  local lib = require('nvim-tree.lib')
  local node = lib.get_node_at_cursor()

  if node.nodes ~= nil and node.open then
    lib.expand_or_collapse(node)
  end
end

function _M.on_right()
  local lib = require('nvim-tree.lib')
  local node = lib.get_node_at_cursor()

  if node.name == '..' then
    return require('nvim-tree.actions.root.change-dir').fn('..')
  end

  if node.nodes ~= nil then
    if not node.open then
      lib.expand_or_collapse(node)
    end
  else
    local path = node.link_to and not node.entries and node.link_to
      or node.absolute_path

    require('nvim-tree.actions.node.open-file').fn('edit', path)
  end
end

function _M.config()
  local list = {
    { key = { '<2-LeftMouse>' }, action = 'edit' },
    { key = { '<2-RightMouse>', '<CR>' }, action = 'cd' },
    { key = 's', action = 'split' },
    { key = 'v', action = 'vsplit' },
    { key = 'l', cb = arrow('right') },
    { key = 'h', cb = arrow('left') },
    { key = '<BS>', action = 'close_node' },
    { key = 't', action = 'tabnew' },
    { key = '<', action = 'prev_sibling' },
    { key = '>', action = 'next_sibling' },
    { key = 'P', action = 'parent_node' },
    { key = '<Tab>', action = 'preview' },
    { key = 'K', action = 'first_sibling' },
    { key = 'J', action = 'last_sibling' },
    { key = 'I', action = 'toggle_ignored' },
    { key = '.', action = 'toggle_dotfiles' },
    { key = 'R', action = 'refresh' },
    { key = 'a', action = 'create' },
    { key = 'd', action = 'remove' },
    { key = 'D', action = 'trash' },
    { key = 'r', action = 'rename' },
    { key = '<C-r>', action = 'full_rename' },
    { key = 'x', cb = 'cut' },
    { key = 'c', cb = 'copy' },
    { key = 'p', cb = 'paste' },
    { key = 'y', cb = 'copy_name' },
    { key = 'Y', cb = 'copy_path' },
    { key = 'gy', action = 'copy_absolute_path' },
    { key = '-', action = 'dir_up' },
    { key = 'o', action = 'system_open' },
    { key = 'q', action = 'close' },
    { key = 'g?', action = 'toggle_help' },
    { key = 'f', action = 'live_filter' },
    { key = 'F', action = 'clear_live_filter' },
  }

  require('nvim-tree').setup({
    respect_buf_cwd = true,
    update_cwd = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_directories = {
      enable = true,
      auto_open = true,
    },
    diagnostics = {
      enable = true,
    },
    actions = {
      change_dir = {
        enable = true,
        global = true,
      },
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    filters = {
      dotfiles = true,
      custom = { 'node_modules', 'dist', 'target', 'vendor' },
    },
    view = {
      mappings = {
        custom_only = true,
        list = list,
      },
      signcolumn = 'yes',
    },
    renderer = {
      indent_markers = { enable = true },
      highlight_git = true,
      icons = {
        show = {
          git = false,
          folder = true,
          file = true,
          folder_arrow = false,
        },
      },
    },
  })

  require('nvim-tree.events').on_tree_open(function()
    vim.opt_local.fillchars:append('vert: ')
    vim.opt_local.statusline = '%#NvimTreeStatusLine#'
  end)
end

return _M
