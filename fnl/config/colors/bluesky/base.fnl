(local lush (require :lush))
(local cp (require :config.colors.bluesky.palette))

(lush (fn [{: sym}]
        [(Normal {:fg cp.white :bg cp.black })
         (NormalFloat [Normal])
         (NormalNC [Normal])

         (Comment {:fg cp.secondary :gui :italic})
         (ColorColumn {:bg cp.almostblack})
         ; (Conceal {}) ; placeholder characters substituted for concealed text (see 'conceallevel')
         (Cursor {:fg cp.black :bg cp.white})
         (lCursor [Cursor])
         (CursorIM [Cursor])
         (CursorColumn {:bg cp.almostblack})
         (CursorLine [CursorColumn])
         (Directory {:fg cp.white})
         (DiffAdd {:fg cp.green})
         (DiffChange {:fg cp.yellow})
         (DiffDelete {:fg cp.red})
         (DiffText {:bg cp.red})
         (EndOfBuffer {:fg cp.grey})
         (TermCursor [Cursor])
         (TermCursorNC [Cursor])
         (ErrorMsg {:fg cp.white :bg cp.red})
         (VertSplit {:fg cp.white :bg cp.black })
         (Folded {:fg cp.almostwhite :gui :italic})
         (FoldColumn {:fg cp.almostwhite :gui :italic})
         (SignColumn {:fg cp.grey})
         (IncSearch {:fg cp.black :bg cp.yellow})
         (Substitute [IncSearch])
         (LineNr {:fg cp.grey})
         (CursorLineNr {:fg cp.blue :bg cp.almostblack})
         (MatchParen {:fg cp.yellow :gui :bold})
         (ModeMsg {:fg cp.blue :gui :bold})
         ; (MsgArea      []) ; Area for messages and cmdline
         ; (MsgSeparator []) ; Separator for scrolled messages, `msgsep` flag of 'display'
         (MoreMsg {:gui :bold})
         (NonText {:fg cp.grey})
         (Pmenu [Normal])
         (PmenuSel {:fg cp.black :bg cp.almostwhite})
         (PmenuSbar {:bg cp.grey})
         (PmenuThumb {:bg cp.white})
         (Question {:fg cp.green :gui :bold})
         (QuickFixLine [PmenuSel])
         (Search [PmenuSel])
         ; (SpecialKey []) ; Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
         ; (SpellBad []) ; Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
         ; (SpellCap []) ; Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
         ; (SpellLocal []) ; Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
         ; (SpellRare []) ; Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
         (StatusLine {:fg cp.white :bg cp.blacker})
         (StatusLineNC {:fg cp.white :bg cp.black})
         ; (TabLine []) ; tab pages line, not active tab page label
         ; (TabLineFill []) ; tab pages line, where there are no labels
         ; (TabLineSel []) ; tab pages line, active tab page label

         (Title {:fg cp.almostwhite})
         (Visual {:fg cp.black :bg cp.almostwhite})
         (VisualNOS [Visual])
         (WarningMsg {:fg cp.red})
         (Whitespace {:fg cp.grey})
         ; (WildMenu []) ; current match in 'wildmenu' completion

         ; These groups are not listed as default vim groups,
         ; but they are defacto standard group names for syntax highlighting.
         ; commented out groups should chain up to their "preferred" group by
         ; default,
         ; Uncomment and edit if you want more specific syntax highlighting.

         (Constant {:fg cp.blue :gui :NONE})
         (String {:fg cp.almostwhite })
         (Character [String])
         (Number [String])
         (Boolean {:fg cp.blue})
         (Float [String])

         (Identifier {:fg cp.white :gui :NONE})
         (Function {:fg cp.white :gui :NONE})

         (Statement {:fg cp.blue})
         (Conditional {:fg cp.blue :gui :italic})
         (Repeat {:fg cp.blue :gui :italic})
         (Label {:fg cp.blue :gui :italic})
         (Operator [])
         (Keyword {:fg cp.blue :gui :italic})
         (Exception {:fg cp.blue :gui :italic})

         (PreProc {:fg cp.blue})
         (Include {:fg cp.blue :gui :italic})
         (Define {:fg cp.blue :gui :italic})
         (Macro {:fg cp.blue})
         (PreCondit {:fg cp.blue :gui :italic})

         (Type {:fg cp.blue :gui :NONE})
         (StorageClass {:fg cp.blue :gui :italic})
         (Structure {:fg cp.blue :gui :italic})
         (Typedef [Type])

         (Special {:fg cp.accent :gui :italic})
         (SpecialChar {:fg cp.accent :gui :italic})
         (Tag [Identifier])
         (Delimiter [Identifier])
         (SpecialComment {:fg cp.accent :gui "bold,italic"})
         (Debug {:fg cp.yellow})

         (Underlined {:gui :underline})
         (Bold {:gui :bold})
         (Italic {:gui :italic})

         (Ignore {:fg cp.black :bg cp.black})

         (Error {:fg cp.black :bg cp.red :gui :bold})

         (Todo {:fg cp.black :bg cp.yellow :gui :bold}) ; (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

         (vimHiTerm [Identifier])

         (luaFunction [Statement])
         (luaOperator [Statement])
         (luaSymbolOperator [Identifier])
         (luaFunc [Special])

         ((sym "@constructor") [Keyword])]))
