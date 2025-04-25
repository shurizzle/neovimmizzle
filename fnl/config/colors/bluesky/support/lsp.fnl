(import-macros {: blush} :config.colors.blush.macros)

;; fnlfmt: skip
(fn [cp]
  (blush
    ;; See :h lsp-highlight
    ;;
    ;; (LspCodeLens) ;; Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
    ;; (LspCodeLensSeparator) ;; Used to color the seperator between two or more code lens.
    ;; (LspSignatureActiveParameter) ;; Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.
    (LspReferenceText CursorLine)
    (LspReferenceWrite CursorLine)
    (LspReferenceRead CursorLine)
    (DiagnosticError :fg cp.red)
    (DiagnosticWarn :fg cp.yellow)
    (DiagnosticInfo :fg cp.almostwhite)
    (DiagnosticHint :fg cp.fg)
    (DiagnosticVirtualTextError :fg cp.red)
    (DiagnosticVirtualTextWarn :fg cp.yellow)
    (DiagnosticVirtualTextInfo :fg cp.almostwhite)
    (DiagnosticVirtualTextHint :fg cp.fg)
    (DiagnosticUnderlineError DiagnosticError +underline)
    (DiagnosticUnderlineWarn DiagnosticWarn +underline)
    (DiagnosticUnderlineInfo DiagnosticInfo +underline)
    (DiagnosticUnderlineHint DiagnosticHint +underline)
    (DiagnosticFloatingError DiagnosticError)
    (DiagnosticFloatingWarn DiagnosticWarn)
    (DiagnosticFloatingInfo DiagnosticInfo)
    (DiagnosticFloatingHint DiagnosticHint)
    (DiagnosticSignError DiagnosticError)
    (DiagnosticSignWarn DiagnosticWarn)
    (DiagnosticSignInfo DiagnosticInfo)
    (DiagnosticSignHint DiagnosticHint)))
