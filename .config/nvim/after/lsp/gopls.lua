return {
  settings = {
    gopls = {
      hints = {
        rangeVariableTypes = true,
        parameterNames = true,
        constantValues = true,
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        functionTypeParameterNames = true,
      },
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}
