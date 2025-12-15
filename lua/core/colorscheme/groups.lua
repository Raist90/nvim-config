local C = require("core.colorscheme.palette")

M = {}

M.setup = function()
  return {
    -- Base highlights
    Normal = { fg = C.fg, bg = C.none },
    NormalFloat = { fg = C.text, bg = C.none },
    NormalNC = { fg = C.fg, bg = C.none },
    FloatBorder = { fg = C.overlay1, bg = C.none }, -- Soft gray-blue border, transparent bg

    -- Syntax groups
    Comment = { fg = C.fg_dim },
    SpecialComment = { link = "Special" },
    Constant = { fg = C.cyan },
    String = { fg = C.string_yellow },
    Character = { fg = C.string_yellow },
    Number = { fg = C.cyan },
    Float = { link = "Number" },
    Boolean = { fg = C.cyan },
    Identifier = { fg = C.fg }, -- Normal text color
    Function = { fg = C.blue },
    Statement = { fg = C.purple },
    Conditional = { fg = C.purple },
    Repeat = { fg = C.purple },
    Label = { fg = C.blue },
    Operator = { fg = C.fg }, -- Normal text color
    Keyword = { fg = C.purple },
    Exception = { fg = C.purple },

    PreProc = { fg = C.cyan },
    Include = { fg = C.purple },
    Define = { fg = C.purple },
    Macro = { fg = C.purple },
    PreCondit = { fg = C.purple },

    Type = { fg = C.cyan },
    StorageClass = { fg = C.purple },
    Structure = { fg = C.cyan },
    Typedef = { fg = C.cyan },

    Special = { fg = C.cyan },
    SpecialChar = { link = "Special" },
    Tag = { fg = C.blue },
    Delimiter = { fg = C.overlay1 }, -- Softer color for brackets/braces
    Debug = { link = "Special" },

    Underlined = { underline = true },
    Bold = { bold = true },
    Italic = { italic = true },

    Error = { fg = C.red, bold = true }, -- Red reserved for errors only
    Todo = { bg = C.yellow, fg = C.base, bold = true },

    -- UI elements
    ColorColumn = { bg = C.surface0 },
    Conceal = { fg = C.overlay1 },
    Cursor = { fg = C.base, bg = C.text },
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    CursorColumn = { bg = C.surface0 },
    CursorLine = { bg = C.surface0 },
    Directory = { fg = C.blue },

    DiffAdd = { bg = C.surface0, fg = C.green },
    DiffChange = { bg = C.surface0, fg = C.blue },
    DiffDelete = { bg = C.surface0, fg = C.red },
    DiffText = { bg = C.surface1, fg = C.blue },

    EndOfBuffer = { fg = C.base },
    ErrorMsg = { fg = C.red, bold = true },
    VertSplit = { fg = C.border },
    WinSeparator = { fg = C.border },
    Folded = { fg = C.overlay1, bg = C.surface0 },
    FoldColumn = { fg = C.overlay0, bg = C.none },
    SignColumn = { fg = C.overlay0, bg = C.none },

    IncSearch = { bg = C.yellow, fg = C.base, bold = true },
    Substitute = { bg = C.red, fg = C.base },

    LineNr = { fg = C.overlay0 },
    CursorLineNr = { fg = C.lavender },

    MatchParen = { fg = C.cyan, bold = true },

    ModeMsg = { fg = C.text, bold = true },
    MsgArea = { fg = C.text },
    MoreMsg = { fg = C.blue },
    NonText = { fg = C.overlay0 },

    Pmenu = { fg = C.overlay2, bg = C.surface0 },
    PmenuSel = { fg = C.text, bg = C.surface1, bold = true },
    PmenuSbar = { bg = C.surface1 },
    PmenuThumb = { bg = C.overlay0 },

    Question = { fg = C.blue },
    QuickFixLine = { bg = C.surface1, bold = true },

    Search = { bg = C.surface1, fg = C.pink },
    SpecialKey = { fg = C.overlay0 },
    SpellBad = { sp = C.red, undercurl = true },
    SpellCap = { sp = C.yellow, undercurl = true },
    SpellLocal = { sp = C.blue, undercurl = true },
    SpellRare = { sp = C.green, undercurl = true },

    StatusLine = { fg = C.text, bg = C.none },
    StatusLineNC = { fg = C.overlay1, bg = C.none },

    -- Custom Statusline components
    Statusline = { fg = C.text, bg = C.none },
    StatuslineGit = { fg = C.purple, bg = C.none, bold = true },
    StatuslineLSP = { fg = C.blue, bg = C.none },
    StatuslineError = { fg = C.red, bg = C.none },
    StatuslineWarn = { fg = C.yellow, bg = C.none },
    StatuslineInfo = { fg = C.blue, bg = C.none },
    StatuslineHint = { fg = C.teal, bg = C.none },
    StatuslineTime = { fg = C.fg_dim, bg = C.none, bold = true },

    TabLine = { bg = C.surface0, fg = C.overlay1 },
    TabLineFill = { bg = C.surface0 },
    TabLineSel = { fg = C.text, bg = C.surface1 },

    Title = { fg = C.blue, bold = true },

    Visual = { bg = C.surface1 },
    VisualNOS = { link = "Visual" },

    WarningMsg = { fg = C.yellow, bold = true },
    Whitespace = { fg = C.overlay0 },
    WildMenu = { link = "PmenuSel" },

    WinBar = { fg = C.text, bg = C.none },
    WinBarNC = { fg = C.overlay1, bg = C.none },

    -- Custom Winbar components
    WinbarActive = { fg = C.blue, bg = C.none, bold = true },
    WinbarInactive = { fg = C.overlay1, bg = C.none },

    -- LSP
    DiagnosticError = { fg = C.red },
    DiagnosticWarn = { fg = C.yellow },
    DiagnosticInfo = { fg = C.blue },
    DiagnosticHint = { fg = C.teal },
    DiagnosticOk = { fg = C.green },

    DiagnosticVirtualTextError = { fg = C.red },
    DiagnosticVirtualTextWarn = { fg = C.yellow },
    DiagnosticVirtualTextInfo = { fg = C.blue },
    DiagnosticVirtualTextHint = { fg = C.teal },

    DiagnosticUnderlineError = { sp = C.red, undercurl = true },
    DiagnosticUnderlineWarn = { sp = C.yellow, undercurl = true },
    DiagnosticUnderlineInfo = { sp = C.blue, undercurl = true },
    DiagnosticUnderlineHint = { sp = C.teal, undercurl = true },

    LspReferenceText = { bg = C.surface1 },
    LspReferenceRead = { bg = C.surface1 },
    LspReferenceWrite = { bg = C.surface1 },

    -- Git
    Added = { fg = C.green },
    Changed = { fg = C.blue },
    Removed = { fg = C.red },

    diffAdded = { fg = C.green },
    diffRemoved = { fg = C.red },
    diffChanged = { fg = C.blue },
    diffOldFile = { fg = C.yellow },
    diffNewFile = { fg = C.orange },
    diffFile = { fg = C.blue },
    diffLine = { fg = C.overlay0 },
    diffIndexLine = { fg = C.teal },

    -- Quickfix
    qfLineNr = { fg = C.yellow },
    qfFileName = { fg = C.blue },

    -- HTML
    htmlH1 = { fg = C.pink, bold = true },
    htmlH2 = { fg = C.blue, bold = true },

    -- Markdown
    markdownHeadingDelimiter = { fg = C.cyan, bold = true },
    markdownCode = { fg = C.flamingo },
    markdownCodeBlock = { fg = C.flamingo },
    markdownLinkText = { fg = C.blue, underline = true },
    markdownH1 = { fg = C.cyan, bold = true },
    markdownH2 = { fg = C.cyan, bold = true },
    markdownH3 = { fg = C.yellow, bold = true },
    markdownH4 = { fg = C.green, bold = true },
    markdownH5 = { fg = C.sapphire, bold = true },
    markdownH6 = { fg = C.lavender, bold = true },

    mkdCodeDelimiter = { bg = C.base, fg = C.text },
    mkdCodeStart = { fg = C.flamingo, bold = true },
    mkdCodeEnd = { fg = C.flamingo, bold = true },

    -- Debugging
    debugPC = { bg = C.crust },
    debugBreakpoint = { bg = C.base, fg = C.overlay0 },

    -- Health
    healthError = { fg = C.red },
    healthSuccess = { fg = C.teal },
    healthWarning = { fg = C.yellow },

    -- Rainbow delimiters
    rainbow1 = { fg = C.cyan },
    rainbow2 = { fg = C.yellow },
    rainbow3 = { fg = C.green },
    rainbow4 = { fg = C.blue },
    rainbow5 = { fg = C.sapphire },
    rainbow6 = { fg = C.lavender },

    -- CSV
    csvCol0 = { fg = C.cyan },
    csvCol1 = { fg = C.yellow },
    csvCol2 = { fg = C.green },
    csvCol3 = { fg = C.cyan },
    csvCol4 = { fg = C.sky },
    csvCol5 = { fg = C.blue },
    csvCol6 = { fg = C.lavender },
    csvCol7 = { fg = C.mauve },
    csvCol8 = { fg = C.pink },

    -- Glyphs
    GlyphPalette1 = { fg = C.cyan },
    GlyphPalette2 = { fg = C.teal },
    GlyphPalette3 = { fg = C.yellow },
    GlyphPalette4 = { fg = C.blue },
    GlyphPalette6 = { fg = C.teal },
    GlyphPalette7 = { fg = C.text },
    GlyphPalette9 = { fg = C.cyan },

    -- Snacks indent
    SnacksIndent = { fg = C.surface2 }, -- Normal indent guides
    SnacksIndentScope = { fg = C.text }, -- Active scope highlight

    -- Blink cmp
    BlinkCmpMenu = { fg = C.text, bg = C.none },
    BlinkCmpMenuBorder = { fg = C.overlay1, bg = C.none }, -- Consistent with FloatBorder
    BlinkCmpMenuSelection = { fg = C.text, bg = C.surface1 }, -- Selected item
    BlinkCmpDoc = { fg = C.text, bg = C.none },
    BlinkCmpDocBorder = { fg = C.overlay1, bg = C.none }, -- Consistent with FloatBorder
    BlinkCmpDocSeparator = { fg = C.surface2, bg = C.none },
    BlinkCmpSignatureHelp = { fg = C.text, bg = C.none },
    BlinkCmpSignatureHelpBorder = { fg = C.overlay1, bg = C.none },

    -- Blink cmp kind icons (with transparent backgrounds)
    BlinkCmpKind = { fg = C.text, bg = C.none },
    BlinkCmpKindText = { fg = C.text, bg = C.none },
    BlinkCmpKindMethod = { fg = C.blue, bg = C.none },
    BlinkCmpKindFunction = { fg = C.blue, bg = C.none },
    BlinkCmpKindConstructor = { fg = C.blue, bg = C.none },
    BlinkCmpKindField = { fg = C.text, bg = C.none },
    BlinkCmpKindVariable = { fg = C.text, bg = C.none },
    BlinkCmpKindClass = { fg = C.cyan, bg = C.none },
    BlinkCmpKindInterface = { fg = C.cyan, bg = C.none },
    BlinkCmpKindModule = { fg = C.purple, bg = C.none },
    BlinkCmpKindProperty = { fg = C.text, bg = C.none },
    BlinkCmpKindUnit = { fg = C.cyan, bg = C.none },
    BlinkCmpKindValue = { fg = C.cyan, bg = C.none },
    BlinkCmpKindEnum = { fg = C.cyan, bg = C.none },
    BlinkCmpKindKeyword = { fg = C.purple, bg = C.none },
    BlinkCmpKindSnippet = { fg = C.string_yellow, bg = C.none },
    BlinkCmpKindColor = { fg = C.cyan, bg = C.none },
    BlinkCmpKindFile = { fg = C.text, bg = C.none },
    BlinkCmpKindReference = { fg = C.text, bg = C.none },
    BlinkCmpKindFolder = { fg = C.blue, bg = C.none },
    BlinkCmpKindEnumMember = { fg = C.cyan, bg = C.none },
    BlinkCmpKindConstant = { fg = C.cyan, bg = C.none },
    BlinkCmpKindStruct = { fg = C.cyan, bg = C.none },
    BlinkCmpKindEvent = { fg = C.purple, bg = C.none },
    BlinkCmpKindOperator = { fg = C.text, bg = C.none },
    BlinkCmpKindTypeParameter = { fg = C.cyan, bg = C.none },

    -- FzfLua
    FzfLuaNormal = { fg = C.text, bg = C.none },
    FzfLuaBorder = { fg = C.overlay1, bg = C.none },
    FzfLuaTitle = { fg = C.blue, bg = C.none, bold = true },
    FzfLuaPreviewNormal = { fg = C.text, bg = C.none },
    FzfLuaPreviewBorder = { fg = C.overlay1, bg = C.none },
    FzfLuaPreviewTitle = { fg = C.cyan, bg = C.none, bold = true },
    FzfLuaCursor = { fg = C.base, bg = C.text },
    FzfLuaCursorLine = { bg = C.surface1 },
    FzfLuaCursorLineNr = { fg = C.purple, bg = C.surface1 },
    FzfLuaPointer = { fg = C.blue, bg = C.none, bold = true }, -- The > cursor indicator
    FzfLuaMarker = { fg = C.purple, bg = C.none, bold = true }, -- The marker for selected items
    FzfLuaSearch = { fg = C.string_yellow, bg = C.none, bold = true },
    FzfLuaScrollBorderEmpty = { fg = C.surface2, bg = C.none },
    FzfLuaScrollBorderFull = { fg = C.cyan, bg = C.none },
    FzfLuaScrollFloatEmpty = { fg = C.surface2, bg = C.none },
    FzfLuaScrollFloatFull = { fg = C.cyan, bg = C.none },
    FzfLuaHelpNormal = { fg = C.text, bg = C.none },
    FzfLuaHelpBorder = { fg = C.overlay1, bg = C.none },

    -- FzfLua file paths and names
    FzfLuaPathColNr = { fg = C.cyan, bg = C.none },
    FzfLuaPathLineNr = { fg = C.purple, bg = C.none },
    FzfLuaBufName = { fg = C.blue, bg = C.none },
    FzfLuaBufNr = { fg = C.overlay1, bg = C.none },
    FzfLuaBufFlagCur = { fg = C.cyan, bg = C.none },
    FzfLuaBufFlagAlt = { fg = C.purple, bg = C.none },
    FzfLuaTabTitle = { fg = C.blue, bg = C.none },
    FzfLuaTabMarker = { fg = C.cyan, bg = C.none },
    FzfLuaHeaderBind = { fg = C.purple, bg = C.none },
    FzfLuaHeaderText = { fg = C.text, bg = C.none },

    -- FzfLua directory and file types
    FzfLuaDirPart = { fg = C.overlay1, bg = C.none },
    FzfLuaFilePart = { fg = C.text, bg = C.none },
    FzfLuaDirIcon = { fg = C.blue, bg = C.none },
    FzfLuaFileIcon = { fg = C.cyan, bg = C.none },

    -- Telescope compatibility (for TelescopeSelection reference in fzf config)
    TelescopeSelection = { fg = C.text, bg = C.surface1, bold = true },

    -- Treesitter Highlights (Strategic, High-Impact)
    -- Base language constructs
    ["@variable"] = { fg = C.text }, -- Variables
    ["@variable.builtin"] = { fg = C.cyan }, -- self, this, super
    ["@variable.parameter"] = { fg = C.text }, -- Function parameters
    ["@variable.member"] = { fg = C.text }, -- Object properties

    ["@constant"] = { fg = C.cyan },
    ["@constant.builtin"] = { fg = C.cyan },
    ["@module"] = { fg = C.text }, -- Imports/modules
    ["@module.builtin"] = { fg = C.cyan },
    ["@label"] = { fg = C.blue },

    -- Functions and methods
    ["@function"] = { fg = C.blue },
    ["@function.builtin"] = { fg = C.blue },
    ["@function.call"] = { fg = C.blue },
    ["@function.method"] = { fg = C.blue },
    ["@function.method.call"] = { fg = C.blue },
    ["@constructor"] = { fg = C.cyan }, -- Constructor calls

    -- Keywords and control flow
    ["@keyword"] = { fg = C.purple },
    ["@keyword.conditional"] = { fg = C.purple },
    ["@keyword.repeat"] = { fg = C.purple },
    ["@keyword.return"] = { fg = C.purple },
    ["@keyword.function"] = { fg = C.purple },
    ["@keyword.operator"] = { fg = C.purple },
    ["@keyword.import"] = { fg = C.purple },
    ["@keyword.export"] = { fg = C.purple },

    -- Operators and punctuation
    ["@operator"] = { fg = C.text },
    ["@punctuation.delimiter"] = { fg = C.overlay1 },
    ["@punctuation.bracket"] = { fg = C.overlay1 },
    ["@punctuation.special"] = { fg = C.cyan },

    -- Types and type annotations
    ["@type"] = { fg = C.cyan },
    ["@type.builtin"] = { fg = C.cyan },
    ["@type.definition"] = { fg = C.cyan },
    ["@type.qualifier"] = { fg = C.purple }, -- const, readonly, etc
    ["@attribute"] = { fg = C.blue }, -- Decorators, annotations
    ["@property"] = { fg = C.text },

    -- Strings and literals
    ["@string"] = { fg = C.string_yellow },
    ["@string.escape"] = { fg = C.cyan },
    ["@string.regexp"] = { fg = C.cyan },
    ["@string.special"] = { fg = C.cyan },
    ["@string.special.symbol"] = { fg = C.cyan },
    ["@character"] = { fg = C.string_yellow },
    ["@character.special"] = { fg = C.cyan },
    ["@number"] = { fg = C.cyan },
    ["@number.float"] = { fg = C.cyan },
    ["@boolean"] = { fg = C.cyan },

    -- Comments
    ["@comment"] = { fg = C.fg_dim },
    ["@comment.documentation"] = { fg = C.overlay1 },

    -- JSX/TSX (React)
    ["@tag"] = { fg = C.cyan }, -- JSX tags like <div>
    ["@tag.builtin"] = { fg = C.cyan }, -- HTML tags
    ["@tag.attribute"] = { fg = C.blue }, -- className, onClick, etc
    ["@tag.delimiter"] = { fg = C.overlay1 }, -- < > / in JSX

    -- TypeScript specific
    ["@type.tsx"] = { fg = C.cyan },
    ["@type.typescript"] = { fg = C.cyan },
    ["@constructor.typescript"] = { fg = C.cyan },
    ["@constructor.tsx"] = { fg = C.cyan },

    -- Lua specific
    ["@constructor.lua"] = { fg = C.overlay1 }, -- Table braces, keep subtle
    ["@field.lua"] = { fg = C.text },
    ["@function.call.lua"] = { fg = C.blue },
    ["@variable.builtin.lua"] = { fg = C.cyan }, -- self

    -- Go specific
    ["@type.go"] = { fg = C.cyan },
    ["@field.go"] = { fg = C.text },
    ["@function.method.go"] = { fg = C.blue },
    ["@namespace.go"] = { fg = C.text }, -- Package names
    ["@constant.go"] = { fg = C.cyan },

    -- Vue specific
    ["@tag.vue"] = { fg = C.cyan },
    ["@tag.attribute.vue"] = { fg = C.blue },

    -- Markup and documentation
    ["@markup.heading"] = { fg = C.cyan, bold = true },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.link"] = { fg = C.blue, underline = true },
    ["@markup.link.url"] = { fg = C.cyan },
    ["@markup.raw"] = { fg = C.string_yellow },
    ["@markup.list"] = { fg = C.cyan },

    -- GraphQL
    ["@type.graphql"] = { fg = C.cyan }, -- Type definitions (User, Post, etc)
    ["@field.graphql"] = { fg = C.text },
    ["@constant.graphql"] = { fg = C.cyan }, -- Enum values
    ["@keyword.graphql"] = { fg = C.purple }, -- query, mutation, type, interface, etc
    ["@operator.graphql"] = { fg = C.purple }, -- on, implements
    ["@variable.graphql"] = { fg = C.blue }, -- Variables like $userId
    ["@parameter.graphql"] = { fg = C.text },
    ["@punctuation.bracket.graphql"] = { fg = C.overlay1 },
    ["@punctuation.delimiter.graphql"] = { fg = C.overlay1 },
    ["@string.graphql"] = { fg = C.string_yellow },
    ["@comment.graphql"] = { fg = C.fg_dim },

    -- JSON
    ["@property.json"] = { fg = C.blue }, -- Property keys
    ["@label.json"] = { fg = C.blue }, -- Property keys
    ["@string.json"] = { fg = C.string_yellow }, -- String values
    ["@number.json"] = { fg = C.cyan }, -- Numbers
    ["@boolean.json"] = { fg = C.cyan }, -- true/false
    ["@constant.builtin.json"] = { fg = C.cyan }, -- null
    ["@punctuation.bracket.json"] = { fg = C.overlay1 }, -- {} []
    ["@punctuation.delimiter.json"] = { fg = C.overlay1 }, -- , :

    -- Bash/Shell
    ["@function.builtin.bash"] = { fg = C.blue }, -- echo, cd, export, etc
    ["@function.bash"] = { fg = C.blue }, -- Custom functions
    ["@keyword.bash"] = { fg = C.purple }, -- if, then, else, fi, for, while, do, done
    ["@keyword.function.bash"] = { fg = C.purple }, -- function keyword
    ["@operator.bash"] = { fg = C.purple }, -- &&, ||, |, >, <
    ["@variable.bash"] = { fg = C.text }, -- $var
    ["@variable.builtin.bash"] = { fg = C.cyan }, -- $HOME, $PATH, $1, $@
    ["@parameter.bash"] = { fg = C.text }, -- Command parameters
    ["@string.bash"] = { fg = C.string_yellow }, -- Strings
    ["@string.special.bash"] = { fg = C.cyan }, -- Command substitution $(...)
    ["@constant.bash"] = { fg = C.cyan }, -- Exit codes, constants
    ["@punctuation.special.bash"] = { fg = C.cyan }, -- $, ${}, etc
    ["@comment.bash"] = { fg = C.fg_dim },

    -- Shell script enhancements
    ["@function.call.bash"] = { fg = C.blue },
    ["@keyword.conditional.bash"] = { fg = C.purple }, -- if, elif, else
    ["@keyword.repeat.bash"] = { fg = C.purple }, -- for, while, until
  }
end

return M
