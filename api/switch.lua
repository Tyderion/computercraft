local function createSwitch( config )
  local function printInfo( )
    print(" ----- Example Use of this createSwitch ----- ")
    print(" -----       1. Configure         ----- ")
    print("")
    print("local switch = createSwitch(")
    print("{")
    print("  ['cases'] = {")
    print("    ['case1'] = 'YES',")
    print("    ['case2'] = function() return 'SomeValue'")
    print("  },")
    print("  ['default'] = 'default Value'")
    print("}")
    print(")")
    print(" -----           2. Use           ----- ")
    print("switch('someval') -- returns 'default value'")
    print("switch('case1') -- returns 'YES'")
    print("switch('case2') -- returns 'SomeValue'")
    print(" -------------------------------------- ")
  end
  if config == nil or config.cases == nil or config.default == nil then
    printInfo()
    return
  end
  local cases = config.cases
  local default = config.default
  switch = function(access)
    result = cases[access]
    if result == nil then
      if type(default) == "function" then
        return default()
      else
        return default
      end
    end
    if type(result) == "function" then
      return result()
    else
      return result
    end
  end
  return switch
end
