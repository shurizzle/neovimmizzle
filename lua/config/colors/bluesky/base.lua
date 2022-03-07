local lush = require('lush')
local cp = require('config.colors.bluesky.palette')

---@diagnostic disable: undefined-global
return lush(function()
  return {
    Normal { fg = cp.white, bg = cp.black },
    NormalFloat { Normal },
    NormalNC { Normal },

    Comment { fg = cp.secondary, gui = 'italic' },
    ColorColumn { bg = cp.almostblack },
    -- Conceal      { }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    Cursor { fg = cp.black, bg = cp.white },
    lCursor { Cursor },
    CursorIM { Cursor },
    CursorColumn { bg = cp.almostblack },
    CursorLine { CursorColumn },
    Directory { fg = cp.white },
    DiffAdd { fg = cp.green },
    DiffChange { fg = cp.yellow },
    DiffDelete { fg = cp.red },
    DiffText { bg = cp.red },
    EndOfBuffer { fg = cp.grey },
    TermCursor { Cursor },
    TermCursorNC { Cursor },
    ErrorMsg { fg = cp.white, bg = cp.red },
    VertSplit { fg = cp.white, bg = cp.black },
    Folded { fg = cp.almostwhite, gui = 'italic' },
    FoldColumn { fg = cp.almostwhite, gui = 'italic' },
    SignColumn { fg = cp.grey },
    IncSearch { fg = cp.black, bg = cp.yellow },
    Substitute { IncSearch },
    LineNr { fg = cp.grey },
    CursorLineNr { fg = cp.blue, bg = cp.almostblack },
    MatchParen { fg = cp.yellow, gui = 'bold' },
    ModeMsg { fg = cp.blue, gui = 'bold' },
    -- MsgArea      { }, -- Area for messages and cmdline
    -- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    MoreMsg { gui = 'bold' },
    NonText { fg = cp.grey },
    Pmenu { Normal },
    PmenuSel { fg = cp.black, bg = cp.almostwhite },
    PmenuSbar { bg = cp.grey },
    PmenuThumb { bg = cp.white },
    Question { fg = cp.green, gui = 'bold' },
    QuickFixLine { PmenuSel },
    Search { PmenuSel },
    -- SpecialKey   { }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    -- SpellBad     { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    -- SpellCap     { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    -- SpellLocal   { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    -- SpellRare    { }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    -- StatusLine   { }, -- status line of current window
    -- StatusLineNC { }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    -- TabLine      { }, -- tab pages line, not active tab page label
    -- TabLineFill  { }, -- tab pages line, where there are no labels
    -- TabLineSel   { }, -- tab pages line, active tab page label
    Title { fg = cp.almostwhite },
    Visual { fg = cp.black, bg = cp.almostwhite },
    VisualNOS { Visual },
    WarningMsg { fg = cp.red },
    Whitespace { fg = cp.grey },
    -- WildMenu     { }, -- current match in 'wildmenu' completion

    -- These groups are not listed as default vim groups,
    -- but they are defacto standard group names for syntax highlighting.
    -- commented out groups should chain up to their "preferred" group by
    -- default,
    -- Uncomment and edit if you want more specific syntax highlighting.

    Constant { fg = cp.blue, gui = 'NONE' },
    String { fg = cp.almostwhite },
    Character { String },
    Number { String },
    Boolean { String },
    Float { String },

    Identifier { fg = cp.white },
    Function { Identifier },

    Statement { Identifier },
    Conditional { fg = cp.blue, gui = 'italic' },
    Repeat { fg = cp.blue, gui = 'italic' },
    Label { fg = cp.blue, gui = 'italic' },
    Operator { Statement },
    Keyword { fg = cp.blue, gui = 'italic' },
    Exception { fg = cp.blue, gui = 'italic' },

    PreProc { fg = cp.blue },
    Include { fg = cp.blue, gui = 'italic' },
    Define { fg = cp.blue, gui = 'italic' },
    Macro { fg = cp.blue },
    PreCondit { fg = cp.blue, gui = 'italic' },

    Type { fg = cp.accent, gui = 'italic' },
    StorageClass { fg = cp.blue, gui = 'italic' },
    Structure { fg = cp.blue, gui = 'italic' },
    Typedef { fg = cp.blue, gui = 'italic' },

    Special { Identifier },
    SpecialChar { Identifier },
    Tag { Identifier },
    Delimiter { Identifier },
    SpecialComment { fg = cp.accent, gui = 'bold,italic' },
    Debug { fg = cp.yellow },

    Underlined { gui = 'underline' },
    Bold { gui = 'bold' },
    Italic { gui = 'italic' },

    Ignore { fg = cp.black, bg = cp.black },

    Error { fg = cp.black, bg = cp.red, gui = 'bold' },

    Todo { fg = cp.black, bg = cp.yellow, gui = 'bold' }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    -- See :h nvim-treesitter-highlights, some groups may not be listed, submit a PR fix to lush-template!
    --
    -- TSAttribute          { } , -- Annotations that can be attached to the code to denote some kind of meta information. e.g. C++/Dart attributes.
    -- TSBoolean            { } , -- Boolean literals: `True` and `False` in Python.
    -- TSCharacter          { } , -- Character literals: `'a'` in C.
    -- TSComment            { } , -- Line comments and block comments.
    -- TSConditional        { } , -- Keywords related to conditionals: `if`, `when`, `cond`, etc.
    -- TSConstant           { } , -- Constants identifiers. These might not be semantically constant. E.g. uppercase variables in Python.
    -- TSConstBuiltin       { } , -- Built-in constant values: `nil` in Lua.
    -- TSConstMacro         { } , -- Constants defined by macros: `NULL` in C.
    -- TSConstructor        { } , -- Constructor calls and definitions: `{}` in Lua, and Java constructors.
    -- TSError              { } , -- Syntax/parser errors. This might highlight large sections of code while the user is typing still incomplete code, use a sensible highlight.
    -- TSException          { } , -- Exception related keywords: `try`, `except`, `finally` in Python.
    -- TSField              { } , -- Object and struct fields.
    -- TSFloat              { } , -- Floating-point number literals.
    -- TSFunction           { } , -- Function calls and definitions.
    -- TSFuncBuiltin        { } , -- Built-in functions: `print` in Lua.
    -- TSFuncMacro          { } , -- Macro defined functions (calls and definitions): each `macro_rules` in Rust.
    -- TSInclude            { } , -- File or module inclusion keywords: `#include` in C, `use` or `extern crate` in Rust.
    -- TSKeyword            { } , -- Keywords that don't fit into other categories.
    -- TSKeywordFunction    { } , -- Keywords used to define a function: `function` in Lua, `def` and `lambda` in Python.
    -- TSKeywordOperator    { } , -- Unary and binary operators that are English words: `and`, `or` in Python; `sizeof` in C.
    -- TSKeywordReturn      { } , -- Keywords like `return` and `yield`.
    -- TSLabel              { } , -- GOTO labels: `label:` in C, and `::label::` in Lua.
    -- TSMethod             { } , -- Method calls and definitions.
    -- TSNamespace          { } , -- Identifiers referring to modules and namespaces.
    -- TSNone               { } , -- No highlighting (sets all highlight arguments to `NONE`). this group is used to clear certain ranges, for example, string interpolations. Don't change the values of this highlight group.
    -- TSNumber             { } , -- Numeric literals that don't fit into other categories.
    -- TSOperator           { } , -- Binary or unary operators: `+`, and also `->` and `*` in C.
    -- TSParameter          { } , -- Parameters of a function.
    -- TSParameterReference { } , -- References to parameters of a function.
    -- TSProperty           { } , -- Same as `TSField`.
    -- TSPunctDelimiter     { } , -- Punctuation delimiters: Periods, commas, semicolons, etc.
    -- TSPunctBracket       { } , -- Brackets, braces, parentheses, etc.
    -- TSPunctSpecial       { } , -- Special punctuation that doesn't fit into the previous categories.
    -- TSRepeat             { } , -- Keywords related to loops: `for`, `while`, etc.
    -- TSString             { } , -- String literals.
    -- TSStringRegex        { } , -- Regular expression literals.
    -- TSStringEscape       { } , -- Escape characters within a string: `\n`, `\t`, etc.
    -- TSStringSpecial      { } , -- Strings with special meaning that don't fit into the previous categories.
    -- TSSymbol             { } , -- Identifiers referring to symbols or atoms.
    -- TSTag                { } , -- Tags like HTML tag names.
    -- TSTagAttribute       { } , -- HTML tag attributes.
    -- TSTagDelimiter       { } , -- Tag delimiters like `<` `>` `/`.
    -- TSText               { } , -- Non-structured text. Like text in a markup language.
    -- TSStrong             { } , -- Text to be represented in bold.
    -- TSEmphasis           { } , -- Text to be represented with emphasis.
    -- TSUnderline          { } , -- Text to be represented with an underline.
    -- TSStrike             { } , -- Strikethrough text.
    -- TSTitle              { } , -- Text that is part of a title.
    -- TSLiteral            { } , -- Literal or verbatim text.
    -- TSURI                { } , -- URIs like hyperlinks or email addresses.
    -- TSMath               { } , -- Math environments like LaTeX's `$ ... $`
    -- TSTextReference      { } , -- Footnotes, text references, citations, etc.
    -- TSEnvironment        { } , -- Text environments of markup languages.
    -- TSEnvironmentName    { } , -- Text/string indicating the type of text environment. Like the name of a `\begin` block in LaTeX.
    -- TSNote               { } , -- Text representation of an informational note.
    TSWarning { fg = cp.yellow },
    TSDanger { fg = cp.red },
    -- TSType               { } , -- Type (and class) definitions and annotations.
    -- TSTypeBuiltin        { } , -- Built-in types: `i32` in Rust.
    -- TSVariable           { } , -- Variable names that don't fit into other categories.
    -- TSVariableBuiltin    { } , -- Variable names defined by the language: `this` or `self` in Javascript.
  }
end)
