set background=dark
hi clear
if exists("syntax")
  syntax reset
endif
let g:colors_name="bluesky"

highlight Normal guifg=#EDEDED guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight! link NormalFloat Normal
highlight! link NormalNC Normal
highlight! link Pmenu Normal
highlight Bold guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight Boolean guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight BufferCurrent guifg=#EDEDED guibg=#545454 guisp=NONE blend=NONE gui=NONE
highlight! link BufferCurrentIndex BufferCurrent
highlight BufferCurrentMod guifg=#FFE100 guibg=#545454 guisp=NONE blend=NONE gui=NONE
highlight BufferCurrentSign guifg=#2E8FFF guibg=#545454 guisp=NONE blend=NONE gui=NONE
highlight BufferCurrentTarget guifg=#CA213D guibg=#545454 guisp=NONE blend=NONE gui=NONE
highlight BufferInactive guifg=#545454 guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight! link BufferInactiveIndex BufferInactive
highlight BufferInactiveMod guifg=#FFE100 guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight BufferInactiveSign guifg=#2E8FFF guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight BufferInactiveTarget guifg=#CA213D guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight BufferOffset guifg=#57A5FF guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight BufferTabpageFill guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight BufferTabpages guifg=NONE guibg=#545454 guisp=NONE blend=NONE gui=NONE
highlight BufferVisible guifg=#EDEDED guibg=#303030 guisp=NONE blend=NONE gui=NONE
highlight! link BufferVisibleIndex BufferVisible
highlight BufferVisibleMod guifg=#FFE100 guibg=#303030 guisp=NONE blend=NONE gui=NONE
highlight BufferVisibleSign guifg=#2E8FFF guibg=#303030 guisp=NONE blend=NONE gui=NONE
highlight BufferVisibleTarget guifg=#CA213D guibg=#303030 guisp=NONE blend=NONE gui=NONE
highlight ColorColumn guifg=NONE guibg=#303030 guisp=NONE blend=NONE gui=NONE
highlight Comment guifg=#757575 guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Conditional guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Constant guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Cursor guifg=#292929 guibg=#EDEDED guisp=NONE blend=NONE gui=NONE
highlight! link CursorIM Cursor
highlight! link TermCursor Cursor
highlight! link TermCursorNC Cursor
highlight! link lCursor Cursor
highlight CursorColumn guifg=NONE guibg=#303030 guisp=NONE blend=NONE gui=NONE
highlight! link CursorLine CursorColumn
highlight CursorLineNr guifg=#2E8FFF guibg=#303030 guisp=NONE blend=NONE gui=NONE
highlight Debug guifg=#FFE100 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Define guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight DiagnosticError guifg=#CA213D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link DiagnosticFloatingError DiagnosticError
highlight! link DiagnosticSignError DiagnosticError
highlight DiagnosticHint guifg=#EDEDED guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link DiagnosticFloatingHint DiagnosticHint
highlight! link DiagnosticSignHint DiagnosticHint
highlight DiagnosticInfo guifg=#80BBFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link DiagnosticFloatingInfo DiagnosticInfo
highlight! link DiagnosticSignInfo DiagnosticInfo
highlight DiagnosticUnderlineError guifg=#CA213D guibg=NONE guisp=NONE blend=NONE gui=underline
highlight DiagnosticUnderlineHint guifg=#EDEDED guibg=NONE guisp=NONE blend=NONE gui=underline
highlight DiagnosticUnderlineInfo guifg=#80BBFF guibg=NONE guisp=NONE blend=NONE gui=underline
highlight DiagnosticUnderlineWarn guifg=#FFE100 guibg=NONE guisp=NONE blend=NONE gui=underline
highlight DiagnosticVirtualTextError guifg=#CA213D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextHint guifg=#EDEDED guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextInfo guifg=#80BBFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextWarn guifg=#FFE100 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticWarn guifg=#FFE100 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link DiagnosticFloatingWarn DiagnosticWarn
highlight! link DiagnosticSignWarn DiagnosticWarn
highlight DiffAdd guifg=#169C50 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiffChange guifg=#FFE100 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiffDelete guifg=#CA213D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiffText guifg=NONE guibg=#CA213D guisp=NONE blend=NONE gui=NONE
highlight Directory guifg=#EDEDED guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight EndOfBuffer guifg=#545454 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Error guifg=#292929 guibg=#CA213D guisp=NONE blend=NONE gui=bold
highlight ErrorMsg guifg=#EDEDED guibg=#CA213D guisp=NONE blend=NONE gui=NONE
highlight Exception guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight FoldColumn guifg=#80BBFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Folded guifg=#80BBFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Function guifg=#EDEDED guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight GitSignsAdd guifg=#169C50 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight GitSignsAddLn guifg=#169C50 guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight GitSignsAddNr guifg=#169C50 guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight GitSignsChange guifg=#FFE100 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight GitSignsChangeLn guifg=#FFE100 guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight GitSignsChangeNr guifg=#FFE100 guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight GitSignsDelete guifg=#CA213D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight GitSignsDeleteLn guifg=#CA213D guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight GitSignsDeleteNr guifg=#CA213D guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight Identifier guifg=#EDEDED guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link Delimiter Identifier
highlight! link Statement Identifier
highlight! link Tag Identifier
highlight Ignore guifg=#292929 guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight IlluminatedWordText guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=underline
highlight! link illuminateWordRead IlluminatedWordText
highlight! link illuminateWordWrite IlluminatedWordText
highlight IncSearch guifg=#292929 guibg=#FFE100 guisp=NONE blend=NONE gui=NONE
highlight! link Substitute IncSearch
highlight Include guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight IndentBlanklineChar guifg=#303030 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight IndentBlanklineContextChar guifg=#EDEDED guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Italic guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Keyword guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight Label guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight LineNr guifg=#545454 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Macro guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight MatchParen guifg=#FFE100 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight ModeMsg guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=bold
highlight MoreMsg guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight NavicBar guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NavicIconsFile guifg=#2E8FFF guibg=#242424 guisp=NONE blend=NONE gui=bold
highlight! link NavicIconsArray NavicIconsFile
highlight! link NavicIconsBoolean NavicIconsFile
highlight! link NavicIconsClass NavicIconsFile
highlight! link NavicIconsConstant NavicIconsFile
highlight! link NavicIconsConstructor NavicIconsFile
highlight! link NavicIconsEnum NavicIconsFile
highlight! link NavicIconsEnumMember NavicIconsFile
highlight! link NavicIconsEvent NavicIconsFile
highlight! link NavicIconsField NavicIconsFile
highlight! link NavicIconsFunction NavicIconsFile
highlight! link NavicIconsInterface NavicIconsFile
highlight! link NavicIconsKey NavicIconsFile
highlight! link NavicIconsMethod NavicIconsFile
highlight! link NavicIconsModule NavicIconsFile
highlight! link NavicIconsNamespace NavicIconsFile
highlight! link NavicIconsNull NavicIconsFile
highlight! link NavicIconsNumber NavicIconsFile
highlight! link NavicIconsObject NavicIconsFile
highlight! link NavicIconsOperator NavicIconsFile
highlight! link NavicIconsPackage NavicIconsFile
highlight! link NavicIconsProperty NavicIconsFile
highlight! link NavicIconsString NavicIconsFile
highlight! link NavicIconsStruct NavicIconsFile
highlight! link NavicIconsTypeParameter NavicIconsFile
highlight! link NavicIconsVariable NavicIconsFile
highlight NavicSeparator guifg=#FFE100 guibg=#242424 guisp=NONE blend=NONE gui=bold
highlight NavicText guifg=#EDEDED guibg=#242424 guisp=NONE blend=NONE gui=italic
highlight NonText guifg=#545454 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NvimTreeEndOfBuffer guifg=#242424 guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeFolderIcon guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NvimTreeIndentMarker guifg=#545454 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NvimTreeNormal guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeNormalNC guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeRootFolder guifg=#80BBFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NvimTreeSignColumn guifg=#242424 guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeStatusLine guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeStatusLineNC guifg=#242424 guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight NvimTreeVertSplit guifg=NONE guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight PmenuSbar guifg=NONE guibg=#545454 guisp=NONE blend=NONE gui=NONE
highlight PmenuSel guifg=#292929 guibg=#80BBFF guisp=NONE blend=NONE gui=NONE
highlight! link QuickFixLine PmenuSel
highlight! link Search PmenuSel
highlight PmenuThumb guifg=NONE guibg=#EDEDED guisp=NONE blend=NONE gui=NONE
highlight PreCondit guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight PreProc guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Question guifg=#169C50 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight Repeat guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight SignColumn guifg=#545454 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Special guifg=#57A5FF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight SpecialChar guifg=#57A5FF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight SpecialComment guifg=#57A5FF guibg=NONE guisp=NONE blend=NONE gui=bold,italic
highlight! link Operator Statement
highlight StatusLine guifg=#EDEDED guibg=#242424 guisp=NONE blend=NONE gui=NONE
highlight StatusLineNC guifg=#EDEDED guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight StorageClass guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight String guifg=#80BBFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link Character String
highlight! link Float String
highlight! link Number String
highlight Structure guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=italic
highlight TSDanger guifg=#292929 guibg=#CA213D guisp=NONE blend=NONE gui=NONE
highlight TSWarning guifg=#292929 guibg=#FFE100 guisp=NONE blend=NONE gui=NONE
highlight TelescopeBorder guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight TelescopeMatching guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=italic,underline
highlight Title guifg=#80BBFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Todo guifg=#292929 guibg=#FFE100 guisp=NONE blend=NONE gui=bold
highlight Type guifg=#2E8FFF guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link Typedef Type
highlight Underlined guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=underline
highlight VertSplit guifg=#EDEDED guibg=#292929 guisp=NONE blend=NONE gui=NONE
highlight Visual guifg=#292929 guibg=#80BBFF guisp=NONE blend=NONE gui=NONE
highlight! link VisualNOS Visual
highlight WarningMsg guifg=#CA213D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Whitespace guifg=#545454 guibg=NONE guisp=NONE blend=NONE gui=NONE
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
  autocmd VimEnter * lua require"config.colors".set_highlight_colors()
  autocmd ColorScheme * lua require"config.colors".set_highlight_colors()
augroup END
    