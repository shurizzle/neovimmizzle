local _M = {}

_M.module_pattern = {
  '^nvim%-tree$',
  '^nvim%-tree%.',
}

_M.cmd = {
  'NvimTreeToggle',
  'NvimTreeFocus',
  'NvimTreeFindFile',
  'NvimTreeCollapse',
}

_M.keys = { { 'n', '<space>e' } }

local function arrow(where)
  return string.format(':lua require\'config.plugins.tree\'.on_%s()<CR>', where)
end

function _M.on_left()
  local lib = require('nvim-tree.lib')
  local node = lib.get_node_at_cursor()

  if not node then return end

  if node.nodes ~= nil and node.open then lib.expand_or_collapse(node) end
end

function _M.on_right()
  local lib = require('nvim-tree.lib')
  local node = lib.get_node_at_cursor()

  if not node then return end

  if node.name == '..' then
    return require('nvim-tree.actions.root.change-dir').fn('..')
  end

  if node.nodes ~= nil then
    if not node.open then lib.expand_or_collapse(node) end
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

  local tree = require('nvim-tree')

  tree.setup({
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

  local view = require('nvim-tree.view')
  local sidebar = require('config.sidebar')
  local sb = nil

  local function is_open() return view.is_visible() end

  local function find_file(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local filepath = require('nvim-tree.utils').canonical_path(
      vim.fn.fnamemodify(bufname, ':p')
    )
    require('nvim-tree.api').tree.find_file(filepath)
  end

  local function raw_open()
    local bufnr = vim.api.nvim_get_current_buf()
    if not is_open() then tree.open() end
    find_file(bufnr)
  end

  local function close() view.close() end

  local function open()
    sidebar.register(
      'Explorer',
      function(cb) sb = { close = cb } end,
      function(ssb)
        sb = ssb
        raw_open()
      end
    )
  end

  local function toggle() return (is_open() and close or open)() end

  vim.keymap.set(
    'n',
    '<space>e',
    toggle,
    { silent = true, noremap = true, desc = 'Toggle nvim-tree' }
  )

  local ev = require('nvim-tree.events')

  ev.subscribe(ev.Event.TreeOpen, function()
    vim.opt_local.fillchars:append('vert: ')
    vim.wo.statusline = '%#NvimTreeStatusLine#'
    ---@diagnostic disable-next-line
    local winnr = view.get_winnr()

    local augroup =
      vim.api.nvim_create_augroup('NvimTreeResize', { clear = true })
    vim.api.nvim_create_autocmd('WinScrolled', {
      pattern = tostring(winnr),
      group = augroup,
      callback = function()
        if sb and sb.resize then
          sb.resize(vim.api.nvim_win_get_width(winnr) + 1)
        end
      end,
    })

    if sb and sb.resize then
      sb.resize(vim.api.nvim_win_get_width(winnr) + 1)
    end
  end)

  ev.subscribe(ev.Event.Resize, function()
    ---@diagnostic disable-next-line
    local winnr = view.get_winnr()
    if sb and sb.resize then
      sb.resize(vim.api.nvim_win_get_width(winnr) + 1)
    end
  end)

  ev.subscribe(ev.Event.TreeClose, function()
    vim.api.nvim_create_augroup('NvimTreeResize', { clear = true })
    if sb then sb.close() end
  end)
end

return _M
