


local tunnel_config = {
  ["length"] = 40,
  ["interval"] = 4,
  ["height"] = 2
  ["width"] = 1
  ["Direction1D"] = right
}

local function switch( config )
    local cases = config.cases
    local default = config.default
    wrapper = function(access)
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
    return wrapper
end
local test = 17
testswitch = switch(
{
  ["cases"] = {
      ["test"] = "YES", -- value case, can also be afunction
      ["fail"] = function() return "Fail " .. test*2 -- function case, can also be a value
  },
  ["default"] = function() return "Default function" .. 5*3 end -- Function default, can be value
}
)

print(testswitch("test")) -- "YES"
print(testswitch("fail")) -- "Fail 34"
print(testswitch("missing")) -- "Default Function 15"
