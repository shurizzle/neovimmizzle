if has('terminal') then
  function _G.term_run(cmd) vim.api.nvim_command('terminal ' .. cmd) end
else
  function _G.term_run(cmd)
    vim.api.nvim_command('noautocmd new | terminal ' .. cmd)
  end
end

function _G.colorscheme(...)
  local names = { ... }
  if #names == 0 then
    return vim.api.nvim_exec('colo', true)
  elseif #names == 1 then
    names = names[1]
  end

  if type(names) == 'string' then
    return vim.api.nvim_exec(
      'try | colo ' .. names .. ' | catch /E185/ | echo \'fail\' | endtry',
      true
    ) ~= 'fail'
  else
    for _, name in pairs(names) do
      if colorscheme(name) then return true end
    end
    return false
  end
end

function _G.tabnext()
  if vim.fn.exists(':BufferNext') ~= 0 then
    vim.api.nvim_command('BufferNext')
  else
    vim.api.nvim_command('tabn')
  end
end

function _G.tabprev()
  if vim.fn.exists(':BufferPrevious') ~= 0 then
    vim.api.nvim_command('BufferPrevious')
  else
    vim.api.nvim_command('tabp')
  end
end

local function capitalize(str)
  str = tostring(str)

  if string.len(str) == 0 then return str end

  return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

local function uncapitalize(str)
  str = tostring(str)

  if string.len(str) == 0 then return str end

  return string.lower(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

local function next_word(str)
  if not str then return end

  str = string.gsub(str, '^[%s-_]+', '')

  if string.len(str) == 0 then return end

  local start, stop = string.find(str, '^[^%a%s-_]*[^%l%s-_]*[^%u%s-_]*')
  local word, rest

  if stop > 0 then
    word = string.lower(string.sub(str, start, stop))
    if (stop + 1) <= string.len(str) then rest = string.sub(str, stop + 1) end
  end

  return word, rest
end

local function split_words(str)
  if not str or string.len(str) == 0 then return end

  local word, rest = next_word(str)

  if word and not rest then
    return word
  elseif not word and rest then
    return split_words(rest)
  elseif not word and not rest then
    return
  else
    return word, split_words(rest)
  end
end

if not vim then _G.vim = {} end

if not vim.tbl_map then
  vim.tbl_map = function(mapper, tbl)
    local res = {}
    for key, value in pairs(tbl) do
      res[key] = mapper(value)
    end
    return res
  end
end

local FORMATTERS = {}

FORMATTERS['upper'] = function(str)
  return table.concat(
    vim.tbl_map(function(x) return string.upper(x) end, { split_words(str) }),
    '_'
  )
end

FORMATTERS['snake'] =
  function(str) return table.concat({ split_words(str) }, '_') end

FORMATTERS['kebab'] =
  function(str) return table.concat({ split_words(str) }, '-') end

FORMATTERS['pascal'] = function(str)
  return table.concat(vim.tbl_map(capitalize, { split_words(str) }), '')
end

FORMATTERS['camel'] =
  function(str) return uncapitalize(FORMATTERS['pascal'](str)) end

_G.convertcase = function(fmt, str)
  if not str or type(str) ~= 'string' then return end
  if string.len(str) == 0 then return str end

  return FORMATTERS[fmt](str)
end

_G.operatorfunction = nil
_G.operatorfunction_apply = function(vmode)
  if type(_G.operatorfunction) == 'function' then
    local fn = _G.operatorfunction
    _G.operatorfunction = nil
    return fn(vmode)
  end
end

_G.set_operatorfunc = function(fn)
  _G.operatorfunction = fn
  vim.o.operatorfunc = 'v:lua.operatorfunction_apply'
end
