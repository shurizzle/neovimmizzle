local M = {}

local function lines(s)
  local result = {}
  for each in s:gmatch("[^\r\n]+") do
      table.insert(result, each)
  end
  return result
end

function M.setup()
  vim.g.dashboard_default_executive = 'telescope'
  vim.g.dashboard_custom_header = lines([[
           d8,                              d8,                 d8b
          `8P                              `8P                  88P
                                                               d88
?88   d8P  88b  88bd8b,d88b   88bd8b,d88b   88bd88888P d88888P 888   d8888b
d88  d8P'  88P  88P'`?8P'?8b  88P'`?8P'?8b  88P   d8P'    d8P' ?88  d8b_,dP
?8b ,88'  d88  d88  d88  88P d88  d88  88P d88  d8P'    d8P'    88b 88b
`?888P'  d88' d88' d88'  88bd88' d88'  88bd88' d88888P'd88888P'  88b`?888P'
]])
end

return M
