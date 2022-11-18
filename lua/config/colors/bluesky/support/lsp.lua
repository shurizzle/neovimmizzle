local lush = require 'lush'
local cp = require 'config.colors.bluesky.palette'

---@diagnostic disable: undefined-global
return lush(function()
  return {
    -- See :h lsp-highlight
    --
    -- LspReferenceText            { } , -- used for highlighting "text" references
    -- LspReferenceRead            { } , -- used for highlighting "read" references
    -- LspReferenceWrite           { } , -- used for highlighting "write" references
    -- LspCodeLens                 { } , -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
    -- LspCodeLensSeparator        { } , -- Used to color the seperator between two or more code lens.
    -- LspSignatureActiveParameter { } , -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

    DiagnosticError { fg = cp.red },
    DiagnosticWarn { fg = cp.yellow },
    DiagnosticInfo { fg = cp.almostwhite },
    DiagnosticHint { fg = cp.white },
    DiagnosticVirtualTextError { fg = cp.red },
    DiagnosticVirtualTextWarn { fg = cp.yellow },
    DiagnosticVirtualTextInfo { fg = cp.almostwhite },
    DiagnosticVirtualTextHint { fg = cp.white },
    DiagnosticUnderlineError { DiagnosticError, gui = 'underline' },
    DiagnosticUnderlineWarn { DiagnosticWarn, gui = 'underline' },
    DiagnosticUnderlineInfo { DiagnosticInfo, gui = 'underline' },
    DiagnosticUnderlineHint { DiagnosticHint, gui = 'underline' },
    DiagnosticFloatingError { DiagnosticError },
    DiagnosticFloatingWarn { DiagnosticWarn },
    DiagnosticFloatingInfo { DiagnosticInfo },
    DiagnosticFloatingHint { DiagnosticHint },
    DiagnosticSignError { DiagnosticError },
    DiagnosticSignWarn { DiagnosticWarn },
    DiagnosticSignInfo { DiagnosticInfo },
    DiagnosticSignHint { DiagnosticHint },
  }
end)
