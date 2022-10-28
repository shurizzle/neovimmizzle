local lush = require('lush')
local cp = require('config.colors.bluesky.palette')

---@diagnostic disable: undefined-global
return lush(function()
  return {
    NavicBar { bg = cp.blacker },
    NavicIconsFile { bg = cp.blacker, fg = cp.blue, gui = 'bold' },
    NavicIconsModule { NavicIconsFile },
    NavicIconsNamespace { NavicIconsFile },
    NavicIconsPackage { NavicIconsFile },
    NavicIconsClass { NavicIconsFile },
    NavicIconsMethod { NavicIconsFile },
    NavicIconsProperty { NavicIconsFile },
    NavicIconsField { NavicIconsFile },
    NavicIconsConstructor { NavicIconsFile },
    NavicIconsEnum { NavicIconsFile },
    NavicIconsInterface { NavicIconsFile },
    NavicIconsFunction { NavicIconsFile },
    NavicIconsVariable { NavicIconsFile },
    NavicIconsConstant { NavicIconsFile },
    NavicIconsString { NavicIconsFile },
    NavicIconsNumber { NavicIconsFile },
    NavicIconsBoolean { NavicIconsFile },
    NavicIconsArray { NavicIconsFile },
    NavicIconsObject { NavicIconsFile },
    NavicIconsKey { NavicIconsFile },
    NavicIconsNull { NavicIconsFile },
    NavicIconsEnumMember { NavicIconsFile },
    NavicIconsStruct { NavicIconsFile },
    NavicIconsEvent { NavicIconsFile },
    NavicIconsOperator { NavicIconsFile },
    NavicIconsTypeParameter { NavicIconsFile },
    NavicText { fg = cp.white, bg = cp.blacker, gui = 'italic' },
    NavicSeparator { fg = cp.yellow, bg = cp.blacker, gui = 'bold' },
  }
end)
