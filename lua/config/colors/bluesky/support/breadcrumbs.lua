local lush = require 'lush'
local cp = require 'config.colors.bluesky.palette'

---@diagnostic disable: undefined-global
return lush(
  function()
    return {
      BreadcrumbsBar { bg = cp.blacker },
      BreadcrumbIconFile { bg = cp.blacker, fg = cp.blue, gui = 'bold' },
      BreadcrumbIconModule { BreadcrumbIconFile },
      BreadcrumbIconNamespace { BreadcrumbIconFile },
      BreadcrumbIconPackage { BreadcrumbIconFile },
      BreadcrumbIconClass { BreadcrumbIconFile },
      BreadcrumbIconMethod { BreadcrumbIconFile },
      BreadcrumbIconProperty { BreadcrumbIconFile },
      BreadcrumbIconField { BreadcrumbIconFile },
      BreadcrumbIconConstructor { BreadcrumbIconFile },
      BreadcrumbIconEnum { BreadcrumbIconFile },
      BreadcrumbIconInterface { BreadcrumbIconFile },
      BreadcrumbIconFunction { BreadcrumbIconFile },
      BreadcrumbIconVariable { BreadcrumbIconFile },
      BreadcrumbIconConstant { BreadcrumbIconFile },
      BreadcrumbIconString { BreadcrumbIconFile },
      BreadcrumbIconNumber { BreadcrumbIconFile },
      BreadcrumbIconBoolean { BreadcrumbIconFile },
      BreadcrumbIconArray { BreadcrumbIconFile },
      BreadcrumbIconObject { BreadcrumbIconFile },
      BreadcrumbIconKey { BreadcrumbIconFile },
      BreadcrumbIconNull { BreadcrumbIconFile },
      BreadcrumbIconEnumMember { BreadcrumbIconFile },
      BreadcrumbIconStruct { BreadcrumbIconFile },
      BreadcrumbIconEvent { BreadcrumbIconFile },
      BreadcrumbIconOperator { BreadcrumbIconFile },
      BreadcrumbIconTypeParameter { BreadcrumbIconFile },
      BreadcrumbText { fg = cp.white, bg = cp.blacker, gui = 'italic' },
      BreadcrumbsSeparator { fg = cp.yellow, bg = cp.blacker, gui = 'bold' },
    }
  end
)
