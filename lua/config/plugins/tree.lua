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

function _M.config()
  local api = require('nvim-tree.api')
  local lib = require('nvim-tree.lib')
  local tree = require('nvim-tree')

  local function on_attach(bufnr)
    ---@param mapping string
    ---@param action function
    ---@param desc string|nil
    local function keymap(mapping, action, desc)
      local opts = {
        buffer = bufnr,
        noremap = true,
        silent = true,
        nowait = true,
      }
      if desc then opts.desc = 'nvim-tree: ' .. desc end

      vim.keymap.set('n', mapping, action, opts)
    end

    local function inject_node(f)
      return function(node, ...)
        node = node or lib.get_node_at_cursor()
        f(node, ...)
      end
    end

    local function edit(mode, node)
      local path = node.absolute_path
      if node.link_to and not node.nodes then path = node.link_to end
      require('nvim-tree.actions.node.open-file').fn(mode, path)
    end

    local function expand(node)
      if node and not node.open then lib.expand_or_collapse(node) end
    end

    local function open_or_expand_or_dir_up(node)
      if node.name == '..' then
        require('nvim-tree.actions.root.change-dir').fn('..')
      elseif node.nodes ~= nil then
        expand(node)
      else
        edit('edit', node)
      end
    end

    local function collapse(node)
      if node and node.nodes ~= nil and node.open then
        lib.expand_or_collapse(node)
      end
    end

    local function cr(node)
      if node.name == '..' then
        require('nvim-tree.actions.root.change-dir').fn('..')
      else
        if node.nodes ~= nil then
          require('nvim-tree.actions.root.change-dir').fn(
            require('nvim-tree.lib').get_last_group_node(node).absolute_path
          )
        else
          edit('edit', node)
        end
      end
    end

    keymap('<2-LeftMouse>', api.node.open.edit, 'Open')
    keymap('<2-RightMouse>', api.tree.change_root_to_node, 'CD')
    keymap('<BS>', api.node.navigate.parent_close, 'Close Directory')
    keymap('<CR>', inject_node(cr), 'Open')
    keymap('<Tab>', api.node.open.preview, 'Open Preview')
    keymap('l', inject_node(open_or_expand_or_dir_up), 'Open')
    keymap('h', inject_node(collapse), 'Collapse')
    keymap('s', api.node.open.horizontal, 'Open: Horizontal Split')
    keymap('v', api.node.open.vertical, 'Open: Vertical Split')
    keymap('r', api.fs.rename, 'Rename')
    keymap('<C-r>', api.fs.rename_sub, 'Rename Full Path')
    keymap('R', api.tree.reload, 'Refresh')
    keymap('I', api.tree.toggle_gitignore_filter, 'Toggle Git Ignore')
    keymap('.', api.tree.toggle_hidden_filter, 'Toggle Dotfiles')
    keymap('-', api.tree.change_root_to_parent, 'Up')
    keymap('a', api.fs.create, 'Create')
    keymap('d', api.fs.remove, 'Delete')
    keymap('D', api.fs.trash, 'Trash')
    keymap('f', api.live_filter.start, 'Filter')
    keymap('F', api.live_filter.clear, 'Filter Clear')
    keymap('g?', api.tree.toggle_help, 'Help')
    keymap('q', api.tree.close, 'Close')
    keymap('x', api.fs.cut, 'Cut')
    keymap('c', api.fs.copy.node, 'Copy')
    keymap('p', api.fs.paste, 'Paste')
    keymap('y', api.fs.copy.filename, 'Copy Name')
    keymap('Y', api.fs.copy.relative_path, 'Copy Relative Path')
    keymap('gy', api.fs.copy.absolute_path, 'Copy Absolute Path')
    keymap('o', api.node.run.system, 'System Open')
    keymap('<', api.node.navigate.sibling.prev, 'Previous Sibling')
    keymap('>', api.node.navigate.sibling.next, 'Next Sibling')
    keymap('P', api.node.navigate.parent, 'Parent Directory')
    keymap('K', api.node.navigate.sibling.first, 'First Sibling')
    keymap('J', api.node.navigate.sibling.last, 'Last Sibling')
    keymap('t', api.node.open.tab, 'Open: New Tab')
  end

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
      signcolumn = 'yes',
    },
    on_attach = on_attach,
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
    if not is_open() then api.tree.open() end
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
