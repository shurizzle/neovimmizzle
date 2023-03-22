local _M = {}

_M.lazy = true

_M.event = 'InsertEnter'

function _M.config()
  local npairs = require('nvim-autopairs')
  local Rule = require('nvim-autopairs.rule')

  npairs.setup()

  -- Not the best but I need angular brackets in Rust
  npairs.add_rule(
    Rule('<', '>', 'rust'):with_pair(
      require('nvim-autopairs.conds').is_bracket_line()
    )
  )
end

return _M
