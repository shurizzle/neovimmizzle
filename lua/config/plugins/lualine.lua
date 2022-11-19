local _M = {}

local function fixed_extension(text, filetypes)
  if type(filetypes) == 'string' then filetypes = { filetypes } end

  return {
    sections = {
      lualine_a = {
        function() return text end,
      },
    },
    inactive_sections = {
      lualine_c = {
        function() return text end,
      },
    },
    filetypes = filetypes,
  }
end

local DEFAULT_OPTS = {
  nerdfont = true,
}

function _M.config()
  local opts = DEFAULT_OPTS

  local symbols = {
    fileformat = {},
    line = 'LN',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    filename = {
      modified = '[+]',
      readonly = '[-]',
      unnamed = '[No Name]',
    },
  }

  if opts.nerdfont then
    symbols.fileformat = {
      unix = '',
      dos = '',
      mac = '',
    }

    symbols.line = ''

    symbols.section_separators = { left = '', right = '' }

    symbols.filename = {
      modified = '',
      readonly = '',
      unnamed = '',
    }
  end

  local function fmt_enc()
    local format = vim.bo.fileformat
    return vim.opt.fileencoding:get()
      .. ' '
      .. (symbols.fileformat[format] or ('[' .. format .. ']'))
  end

  local function file_status()
    local res = {}
    if vim.bo.modified then table.insert(res, symbols.filename.modified) end
    if vim.bo.modifiable == false or vim.bo.readonly == true then
      table.insert(res, symbols.filename.readonly)
    end

    local res = table.concat(res, ' ')
    if string.len(res) > 0 then res = ' ' .. res end
    return res
  end

  local function pos() return symbols.line .. ':%l:%v/%L %p%%' end

  local space = {
    function()
      if opts.nerdfont then
        return ' '
      else
        return ''
      end
    end,
    padding = false,
  }

  require('lualine').setup({
    options = {
      icons_enabled = opts.nerdfont,
      theme = 'bluesky',
      component_separators = symbols.component_separators,
      section_separators = symbols.section_separators,
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diagnostics' },
      lualine_c = {
        file_status,
        'lsp_progress',
      },

      lualine_x = { 'filetype' },
      lualine_y = { fmt_enc },
      lualine_z = { pos },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        file_status,
      },
      lualine_x = { 'filetype' },
      lualine_y = { fmt_enc, space, pos },
      lualine_z = {},
    },
    tabline = {},
    extensions = {
      fixed_extension('Telescope', 'TelescopePrompt'),
      fixed_extension('Explorer', 'NvimTree'),
      fixed_extension('Input', 'DressingInput'),
      fixed_extension('Dashboard', 'alpha'),
      fixed_extension('Scopes', 'dapui_scopes'),
      fixed_extension('Breakpoints', 'dapui_breakpoints'),
      fixed_extension('Stacks', 'dapui_stacks'),
      fixed_extension('Watches', 'dapui_watches'),
    },
  })
end

return _M
