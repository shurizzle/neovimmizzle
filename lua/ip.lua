local _M = {}

---Parse IPv4
---@param str string
---@return table|nil
function _M.parse4(str)
  vim.validate({
    str = { str, 's' },
  })

  local octects =
    { str:match('^(%d?%d?%d)%.(%d?%d?%d)%.(%d?%d?%d)%.(%d?%d?%d)$') }

  if #octects == 0 then
    return
  end

  for index, value in ipairs(octects) do
    octects[index] = tonumber(value)

    if octects[index] > 255 then
      return
    end
  end

  return octects
end

local HEXMAP = {
  ['0'] = 0,
  ['1'] = 1,
  ['2'] = 2,
  ['3'] = 3,
  ['4'] = 4,
  ['5'] = 5,
  ['6'] = 6,
  ['7'] = 7,
  ['8'] = 8,
  ['9'] = 9,
  ['a'] = 10,
  ['A'] = 10,
  ['b'] = 11,
  ['B'] = 11,
  ['c'] = 12,
  ['C'] = 12,
  ['d'] = 13,
  ['D'] = 13,
  ['e'] = 14,
  ['E'] = 14,
  ['f'] = 15,
  ['F'] = 15,
}

local function from_hex(hex)
  local res = 0
  for i = 1, #hex, 1 do
    local v = HEXMAP[hex:sub(i, i)]
    if v ~= nil then
      res = res * 16 + v
    else
      return
    end
  end
  return res
end

local function convert_ipv4(str)
  local i, j = str:find(':%d?%d?%d%.%d?%d?%d%.%d?%d?%d%.%d?%d?%d$')
  if i then
    local ipv4 = _M.parse4(str:sub(i + 1, j))
    if not ipv4 then
      return
    end
    str = str:sub(0, i)
      .. string.format(
        '%x:%x',
        bit.bor(bit.lshift(ipv4[1], 8), ipv4[2]),
        bit.bor(bit.lshift(ipv4[3], 8), ipv4[4])
      )
  end
  return str
end

local function parse_bits(str, collected)
  local matches = str:match('^(%x?%x?%x?%x)')
  local piece
  if matches then
    piece = from_hex(matches)
    if not piece then
      return
    end

    local len = #matches + 1
    if str:sub(len, len) == ':' then
      len = len + 1
    end
    str = str:sub(len)
  else
    print(string.format('no matches \'%s\'', str))
    return
  end
  if #str == 0 then
    str = nil
  end

  collected = collected or {}
  table.insert(collected, piece)

  if str then
    return parse_bits(str, collected)
  else
    return collected
  end
end

---Parse IPv6
---@param str string
---@return table|nil
function _M.parse6(str)
  vim.validate({
    str = { str, 's' },
  })

  ---@diagnostic disable-next-line
  str = convert_ipv4(str)

  if not str then
    return
  end

  local i, j = str:find('::')
  local head, tail

  if i then
    head = i == 1 and '' or str:sub(0, i - 1)
    tail = str:sub(j + 1)

    if #head == 0 then
      head = nil
    end

    if #tail == 0 then
      tail = nil
    end
  else
    head = str
    tail = nil
  end

  if head then
    head = parse_bits(head)
  else
    head = {}
  end

  if not head then
    return
  end

  if tail then
    tail = parse_bits(tail)
  else
    tail = {}
  end

  if not tail then
    return
  end

  for _ = 1, (8 - (#head + #tail)), 1 do
    table.insert(head, 0)
  end

  for _, value in ipairs(tail) do
    table.insert(head, value)
  end

  return head
end

---Parse IP
---@param str string
---@return table|nil
function _M.parse(str)
  return _M.parse4(str) or _M.parse6(str)
end

return _M
