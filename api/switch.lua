local function create( config )
  local function printInfo( )
    print(" ----- Example Use of this create ----- ")
    print(" -----       1. Configure         ----- ")
    print("")
    print("os.loadAPI('switch')")
    print("local switcher = switch.create(")
    print("{")
    print("  ['cases'] = {")
    print("    ['case1'] = 'YES',")
    print("    ['case2'] = function() return 'SomeValue'")
    print("  },")
    print("  ['default'] = 'default Value'")
    print("}")
    print(")")
    print(" -----           2. Use           ----- ")
    print("switcher('someval') -- returns 'default value'")
    print("switcher('case1') -- returns 'YES'")
    print("switcher('case2') -- returns 'SomeValue'")
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
