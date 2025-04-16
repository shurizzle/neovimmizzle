(import-macros {: blush} :config.colors.blush.macros)

;; fnlfmt: skip
(fn [cp]
  (blush
    (Normal :fg cp.fg)
    (NormalFloat Normal)
    (NormalNC Normal)
    (WinBar Normal)
    (WinBarNC NormalNC)
    (Comment :fg cp.secondary +italic)
    (ColorColumn :bg cp.almostbg)
    ;; (Conceal) ;; placeholder characters substituted for concealed text (see 'conceallevel')
    (Cursor :fg cp.bg :bg cp.fg)
    (lCursor Cursor)
    (CursorIM Cursor)
    (CursorColumn :bg cp.almostbg)
    (CursorLine CursorColumn)
    (Directory :fg cp.fg)
    (DiffAdd :fg cp.green)
    (DiffChange :fg cp.yellow)
    (DiffDelete :fg cp.red)
    (DiffText :bg cp.red)
    (EndOfBuffer :fg cp.grey)
    (TermCursor +reverse)
    (TermCursorNC)
    (ErrorMsg :fg cp.fg :bg cp.red)
    (VertSplit :fg cp.fg)
    (Folded :fg cp.almostwhite +italic)
    (FoldColumn :fg cp.almostwhite +italic)
    (SignColumn :fg cp.grey)
    (IncSearch :fg cp.bg :bg cp.yellow)
    (Substitute IncSearch)
    (LineNr :fg cp.grey)
    (CursorLineNr :fg cp.blue :bg cp.almostbg)
    (MatchParen :fg cp.yellow +bold)
    (ModeMsg :fg cp.blue +bold)
    ;; (MsgArea) ;; Area for messages and cmdline
    ;; (MsgSeparator) ;; Separator for scrolled messages, `msgsep` flag of 'display'
    (MoreMsg +bold)
    (NonText :fg cp.grey)
    (Pmenu Normal)
    (PmenuSel :fg cp.bg :bg cp.almostwhite)
    (PmenuSbar :bg cp.grey)
    (PmenuThumb :bg cp.fg)
    (Question :fg cp.green +bold)
    (QuickFixLine PmenuSel)
    (Search PmenuSel)
    ;; (SpecialKey) ;; Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    (SpellBad :fg cp.fg :bg cp.red)
    ;; Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    (SpellCap :fg cp.fg :bg cp.red)
    ;; Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    (SpellLocal :fg cp.fg :bg cp.red)
    ;; Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    (SpellRare :fg cp.fg :bg cp.red)
    ;; Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    (StatusLine :fg cp.fg :bg cp.bg+)
    (StatusLineNC :fg cp.fg)
    ;; (TabLine) ;; tab pages line, not active tab page label
    ;; (TabLineFill) ;; tab pages line, where there are no labels
    ;; (TabLineSel) ;; tab pages line, active tab page label
    (Title :fg cp.almostwhite)
    (Visual :fg cp.bg :bg cp.almostwhite)
    (VisualNOS Visual)
    (WarningMsg :fg cp.red)
    (Whitespace :fg cp.grey)
    ;; (WildMenu) ;; current match in 'wildmenu' completion
    ;; These groups are not listed as default vim groups,
    ;; but they are defacto standard group names for syntax highlighting.
    ;; commented out groups should chain up to their "preferred" group by
    ;; default,
    ;; Uncomment and edit if you want more specific syntax highlighting.
    (Constant :fg cp.blue)
    (String :fg cp.almostwhite)
    (Character String)
    (Number String)
    (Boolean :fg cp.blue)
    (Float String)
    (Identifier :fg cp.fg)
    (Function :fg cp.fg)
    (Statement :fg cp.blue)
    (Conditional :fg cp.blue +italic)
    (Repeat :fg cp.blue +italic)
    (Label :fg cp.blue +italic)
    (Operator)
    (Keyword :fg cp.blue +italic)
    (Exception :fg cp.blue +italic)
    (PreProc :fg cp.blue)
    (Include :fg cp.blue +italic)
    (Define :fg cp.blue +italic)
    (Macro :fg cp.blue)
    (PreCondit :fg cp.blue +italic)
    (Type :fg cp.blue)
    (StorageClass :fg cp.blue +italic)
    (Structure :fg cp.blue +italic)
    (Typedef Type)
    (Special :fg cp.accent +italic)
    (SpecialChar :fg cp.accent +italic)
    (Tag Identifier)
    (Delimiter Identifier)
    (SpecialComment :fg cp.accent +bold +italic)
    (Debug :fg cp.yellow)
    (Underlined +underline)
    (Bold +bold)
    (Italic +italic)
    (Ignore :fg cp.bg)
    (Error :fg cp.bg :bg cp.red +bold)
    (Todo :fg cp.bg :bg cp.yellow +bold)
    ;; (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
    (vimHiTerm Identifier)
    (luaFunction Statement)
    (luaOperator Statement)
    (luaSymbolOperator Identifier)
    (luaFunc Special)
    ("@constructor" Keyword)))

