set background=dark
hi clear
if exists("syntax")
  syntax reset
endif
let g:colors_name="bluesky"

highlight! link @constructor Keyword
highlight @embedded guifg=#EEEEEE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Bold guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight Boolean guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link BreadcrumbIconArray BreadcrumbIconFile
highlight! link BreadcrumbIconBoolean BreadcrumbIconFile
highlight! link BreadcrumbIconClass BreadcrumbIconFile
highlight! link BreadcrumbIconConstant BreadcrumbIconFile
highlight! link BreadcrumbIconConstructor BreadcrumbIconFile
highlight! link BreadcrumbIconEnum BreadcrumbIconFile
highlight! link BreadcrumbIconEnumMember BreadcrumbIconFile
highlight! link BreadcrumbIconEvent BreadcrumbIconFile
highlight! link BreadcrumbIconField BreadcrumbIconFile
highlight BreadcrumbIconFile guifg=#2F90FE guibg=#242424 guisp=NONE blend=NONE gui=bold
highlight! link BreadcrumbIconFunction BreadcrumbIconFile
highlight! link BreadcrumbIconInterface BreadcrumbIconFile
highlight! link BreadcrumbIconKey BreadcrumbIconFile
highlight! link BreadcrumbIconMethod BreadcrumbIconFile
highlight! link BreadcrumbIconModule BreadcrumbIconFile
highlight! link BreadcrumbIconNamespace BreadcrumbIconFile
highlight! link BreadcrumbIconNull BreadcrumbIconFile
highlight! link BreadcrumbIconNumber BreadcrumbIconFile
highlight! link BreadcrumbIconObject BreadcrumbIconFile
highlight! link BreadcrumbIconOperator BreadcrumbIconFile
highlight! link BreadcrumbIconPackage BreadcrumbIconFile
highlight! link BreadcrumbIconProperty BreadcrumbIconFile
highlight! link BreadcrumbIconString BreadcrumbIconFile
highlight! link BreadcrumbIconStruct BreadcrumbIconFile
highlight! link BreadcrumbIconTypeParameter BreadcrumbIconFile
highlight! link BreadcrumbIconVariable BreadcrumbIconFile
highlight BreadcrumbText guifg=#EEEEEE guibg=#242424 guisp=NONE blend=NONE gui=italic
highlight BreadcrumbsBar guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight BreadcrumbsSeparator guifg=#FFE300 guibg=#242424 guisp=NONE blend=NONE gui=bold
highlight BufferCurrent guifg=#EEEEEE guibg=#535353 guisp=NONE blend=NONE gui=NONE
highlight! link BufferCurrentIndex BufferCurrent
highlight BufferCurrentMod guifg=#FFE300 guibg=#535353 guisp=NONE blend=NONE gui=NONE
highlight BufferCurrentSign guifg=#2F90FE guibg=#535353 guisp=NONE blend=NONE gui=NONE
highlight BufferCurrentTarget guifg=#C8213D guibg=#535353 guisp=NONE blend=NONE gui=NONE
highlight BufferInactive guifg=#535353 guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight! link BufferInactiveIndex BufferInactive
highlight BufferInactiveMod guifg=#FFE300 guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight BufferInactiveSign guifg=#2F90FE guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight BufferInactiveTarget guifg=#C8213D guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight BufferOffset guifg=#58A6FF guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight BufferTabpageFill guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight BufferTabpages guifg=NONE guibg=#535353 guisp=NONE blend=NONE gui=NONE
highlight BufferVisible guifg=#EEEEEE guibg=#2E2E2E guisp=NONE blend=NONE gui=NONE
highlight! link BufferVisibleIndex BufferVisible
highlight BufferVisibleMod guifg=#FFE300 guibg=#2E2E2E guisp=NONE blend=NONE gui=NONE
highlight BufferVisibleSign guifg=#2F90FE guibg=#2E2E2E guisp=NONE blend=NONE gui=NONE
highlight BufferVisibleTarget guifg=#C8213D guibg=#2E2E2E guisp=NONE blend=NONE gui=NONE
highlight! link Character String
highlight ColorColumn guifg=NONE guibg=#2E2E2E guisp=NONE blend=NONE gui=NONE
highlight Comment guifg=#757575 guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Conditional guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Constant guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Cursor guifg=#282828 guibg=#EEEEEE guisp=NONE blend=NONE gui=NONE
highlight CursorColumn guifg=NONE guibg=#2E2E2E guisp=NONE blend=NONE gui=NONE
highlight! link CursorIM Cursor
highlight! link CursorLine CursorColumn
highlight CursorLineNr guifg=#2F90FE guibg=#2E2E2E guisp=NONE blend=NONE gui=NONE
highlight Debug guifg=#FFE300 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Define guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight! link Delimiter Identifier
highlight DiagnosticError guifg=#C8213D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link DiagnosticFloatingError DiagnosticError
highlight! link DiagnosticFloatingHint DiagnosticHint
highlight! link DiagnosticFloatingInfo DiagnosticInfo
highlight! link DiagnosticFloatingWarn DiagnosticWarn
highlight DiagnosticHint guifg=#EEEEEE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticInfo guifg=#82BCFE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link DiagnosticSignError DiagnosticError
highlight! link DiagnosticSignHint DiagnosticHint
highlight! link DiagnosticSignInfo DiagnosticInfo
highlight! link DiagnosticSignWarn DiagnosticWarn
highlight DiagnosticUnderlineError guifg=#C8213D guibg=NONE guisp=NONE blend=NONE gui=underline
highlight DiagnosticUnderlineHint guifg=#EEEEEE guibg=NONE guisp=NONE blend=NONE gui=underline
highlight DiagnosticUnderlineInfo guifg=#82BCFE guibg=NONE guisp=NONE blend=NONE gui=underline
highlight DiagnosticUnderlineWarn guifg=#FFE300 guibg=NONE guisp=NONE blend=NONE gui=underline
highlight DiagnosticVirtualTextError guifg=#C8213D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextHint guifg=#EEEEEE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextInfo guifg=#82BCFE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextWarn guifg=#FFE300 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticWarn guifg=#FFE300 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiffAdd guifg=#169C51 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiffChange guifg=#FFE300 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiffDelete guifg=#C8213D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiffText guifg=NONE guibg=#C8213D guisp=NONE blend=NONE gui=NONE
highlight Directory guifg=#EEEEEE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight EndOfBuffer guifg=#535353 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Error guifg=#282828 guibg=#C8213D guisp=NONE blend=NONE gui=bold
highlight ErrorMsg guifg=#EEEEEE guibg=#C8213D guisp=NONE blend=NONE gui=NONE
highlight Exception guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight! link Float String
highlight FoldColumn guifg=#82BCFE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Folded guifg=#82BCFE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Function guifg=#EEEEEE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight GitSignsAdd guifg=#169C51 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight GitSignsAddLn guifg=#169C51 guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight GitSignsAddNr guifg=#169C51 guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight GitSignsChange guifg=#FFE300 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight GitSignsChangeLn guifg=#FFE300 guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight GitSignsChangeNr guifg=#FFE300 guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight GitSignsDelete guifg=#C8213D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight GitSignsDeleteLn guifg=#C8213D guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight GitSignsDeleteNr guifg=#C8213D guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight IblIndent guifg=#2E2E2E guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight IblScope guifg=#EEEEEE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Identifier guifg=#EEEEEE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Ignore guifg=#282828 guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight IlluminatedWordText guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=underline
highlight IncSearch guifg=#282828 guibg=#FFE300 guisp=NONE blend=NONE gui=NONE
highlight Include guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Italic guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Keyword guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Label guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight LineNr guifg=#535353 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Macro guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight MatchParen guifg=#FFE300 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight ModeMsg guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight MoreMsg guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight NonText guifg=#535353 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Normal guifg=#EEEEEE guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight! link NormalFloat Normal
highlight! link NormalNC Normal
highlight! link Number String
highlight NvimTreeEndOfBuffer guifg=#242424 guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeFolderIcon guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NvimTreeIndentMarker guifg=#535353 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NvimTreeNormal guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeNormalNC guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeRootFolder guifg=#82BCFE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NvimTreeSignColumn guifg=#242424 guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeStatusLine guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeStatusLineNC guifg=#242424 guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeVertSplit guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight clear Operator
highlight! link Pmenu Normal
highlight PmenuSbar guifg=NONE guibg=#535353 guisp=NONE blend=NONE gui=NONE
highlight PmenuSel guifg=#282828 guibg=#82BCFE guisp=NONE blend=NONE gui=NONE
highlight PmenuThumb guifg=NONE guibg=#EEEEEE guisp=NONE blend=NONE gui=NONE
highlight PreCondit guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight PreProc guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Question guifg=#169C51 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link QuickFixLine PmenuSel
highlight Repeat guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight! link Search PmenuSel
highlight SignColumn guifg=#535353 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Special guifg=#58A6FF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight SpecialChar guifg=#58A6FF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight SpecialComment guifg=#58A6FF guibg=NONE guisp=NONE blend=NONE gui=bold,italic
highlight SpellBad guifg=#EEEEEE guibg=#C8213D guisp=NONE blend=NONE gui=NONE
highlight SpellCap guifg=#EEEEEE guibg=#C8213D guisp=NONE blend=NONE gui=NONE
highlight SpellLocal guifg=#EEEEEE guibg=#C8213D guisp=NONE blend=NONE gui=NONE
highlight SpellRare guifg=#EEEEEE guibg=#C8213D guisp=NONE blend=NONE gui=NONE
highlight Statement guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight StatusLine guifg=#EEEEEE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight StatusLineNC guifg=#EEEEEE guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight StorageClass guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight String guifg=#82BCFE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Structure guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight! link Substitute IncSearch
highlight TSDanger guifg=#282828 guibg=#C8213D guisp=NONE blend=NONE gui=NONE
highlight TSWarning guifg=#282828 guibg=#FFE300 guisp=NONE blend=NONE gui=NONE
highlight! link Tag Identifier
highlight TelescopeBorder guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight TelescopeMatching guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=italic,underline
highlight TermCursor guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=reverse
highlight clear TermCursorNC
highlight Title guifg=#82BCFE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Todo guifg=#282828 guibg=#FFE300 guisp=NONE blend=NONE gui=bold
highlight Type guifg=#2F90FE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link Typedef Type
highlight Underlined guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=underline
highlight VertSplit guifg=#EEEEEE guibg=#282828 guisp=NONE blend=NONE gui=NONE
highlight Visual guifg=#282828 guibg=#82BCFE guisp=NONE blend=NONE gui=NONE
highlight! link VisualNOS Visual
highlight WarningMsg guifg=#C8213D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Whitespace guifg=#535353 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link WinBar Normal
highlight! link WinBarNC NormalNC
highlight! link illuminateWordRead IlluminatedWordText
highlight! link illuminateWordWrite IlluminatedWordText
highlight! link lCursor Cursor
highlight! link luaFunc Special
highlight! link luaFunction Statement
highlight! link luaOperator Statement
highlight! link luaSymbolOperator Identifier
highlight prologClause guifg=#EEEEEE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link vimHiTerm Identifier
let g:terminal_color_fg = "#eeeeee"
let g:terminal_color_bg = "#282828"
let g:terminal_color_0 = "#282828"
let g:terminal_color_1 = "#c8213d"
let g:terminal_color_2 = "#169C51"
let g:terminal_color_3 = "#DAAF19"
let g:terminal_color_4 = "#2F90FE"
let g:terminal_color_5 = "#C14ABE"
let g:terminal_color_6 = "#48C6DB"
let g:terminal_color_7 = "#CBCBCB"
let g:terminal_color_8 = "#505050"
let g:terminal_color_9 = "#C7213D"
let g:terminal_color_10 = "#1ef15f"
let g:terminal_color_11 = "#FFE300"
let g:terminal_color_12 = "#00aeff"
let g:terminal_color_13 = "#FF40BE"
let g:terminal_color_14 = "#48FFFF"
let g:terminal_color_15 = "#FFFFFF"
augroup set_highlight_colors
  au!
  autocmd VimEnter * lua require"config.colors"['set-highlight-colors']()
  autocmd ColorScheme * lua require"config.colors"['set-highlight-colors']()
augroup END