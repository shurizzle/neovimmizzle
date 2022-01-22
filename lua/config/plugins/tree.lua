local _M = {}

local function arrow(where)
  return string.format(':lua require\'config.plugins.tree\'.on_%s()<CR>', where)
end

function _M.on_left()
  local lib = require('nvim-tree.lib')
  local node = lib.get_node_at_cursor()

  if node.entries ~= nil and node.open then
    lib.expand_or_collapse(node)
  end
end

function _M.on_right()
  local lib = require('nvim-tree.lib')
  local node = lib.get_node_at_cursor()

  if node.entries ~= nil then
    if not node.open then
      lib.expand_or_collapse(node)
    end
  else
    local path = node.link_to and not node.entries and node.link_to or node.absolute_path

    require('nvim-tree.actions.open-file').fn('open', path)
  end
end

function _M.setup()
  vim.g.nvim_tree_git_hl = 1
  vim.g.nvim_tree_show_icons = {
    git = 0,
    folders = 1,
    files = 1,
    folder_arrows = 0,
  }
  vim.g.nvim_tree_respect_buf_cwd = 1
  vim.g.nvim_tree_indent_markers = 1
end

function _M.config()
  local tree_cb = require('nvim-tree.config').nvim_tree_callback

  local list = {
    { key = { '<CR>', '<2-LeftMouse>' }, cb = tree_cb('edit') },
    { key = { '<2-RightMouse>', '<C-]>' }, cb = tree_cb('cd') },
    { key = { 's' }, cb = tree_cb('split') },
    { key = { 'v' }, cb = tree_cb('vsplit') },
    { key = { 'l' }, cb = arrow('right') },
    { key = { 'h' }, cb = arrow('left') },
    { key = 't', cb = tree_cb('tabnew') },
    { key = '<', cb = tree_cb('prev_sibling') },
    { key = '>', cb = tree_cb('next_sibling') },
    { key = 'P', cb = tree_cb('parent_node') },
    { key = '<BS>', cb = tree_cb('close_node') },
    { key = '<S-CR>', cb = tree_cb('close_node') },
    { key = '<Tab>', cb = tree_cb('preview') },
    { key = 'K', cb = tree_cb('first_sibling') },
    { key = 'J', cb = tree_cb('last_sibling') },
    { key = 'I', cb = tree_cb('toggle_ignored') },
    { key = '.', cb = tree_cb('toggle_dotfiles') },
    { key = 'R', cb = tree_cb('refresh') },
    { key = 'a', cb = tree_cb('create') },
    { key = 'd', cb = tree_cb('remove') },
    { key = 'D', cb = tree_cb('trash') },
    { key = 'r', cb = tree_cb('rename') },
    { key = '<C-r>', cb = tree_cb('full_rename') },
    { key = 'x', cb = tree_cb('cut') },
    { key = 'c', cb = tree_cb('copy') },
    { key = 'p', cb = tree_cb('paste') },
    { key = 'y', cb = tree_cb('copy_name') },
    { key = 'Y', cb = tree_cb('copy_path') },
    { key = 'gy', cb = tree_cb('copy_absolute_path') },
    { key = '[c', cb = tree_cb('prev_git_item') },
    { key = ']c', cb = tree_cb('next_git_item') },
    { key = '-', cb = tree_cb('dir_up') },
    { key = 'o', cb = tree_cb('system_open') },
    { key = 'q', cb = tree_cb('close') },
    { key = 'g?', cb = tree_cb('toggle_help') },
  }

  require('nvim-tree').setup({
    hijack_cursor = true,
    diagnostics = { enable = true },
    update_cwd = true,
    filters = {
      dotfiles = true,
      custom = { 'node_modules', 'dist', 'target', 'vendor' },
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    view = {
      mappings = {
        custom_only = true,
        list = list,
      },
      signcolumn = 'yes',
    },
  })

  local view = require('nvim-tree.view')
  view.View.winopts['fillchars+'] = 'vert:\\ '
  view.View.winopts.statusline = '%#NvimTreeStatusLine#'
end

return _M
