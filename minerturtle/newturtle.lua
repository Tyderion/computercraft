-- Directions
local Direction = {}
Direction.left = "left"
Direction.right = "right"
Direction.forward = "forward"
Direction.back = "back"
Direction.up = "up"
Direction.down = "down"
Direction.isValid = function(direction)
  local dir = string.lower(direction)
  return dir == Direction.left or
         dir == Direction.right or
         dir == Direction.forward or
         dir == Direction.back or
         dir == Direction.up or
         dir == Direction.down
end
Direction.new = function(initial)
  local self = {
    current = Direction.left
  }
  if Direction.isValid(initial) then
     self.current = initial
  end

  function self.opposite(test)
    switch = {
      [Direction.left] = Direction.right,
      [Direction.right]= Direction.left,
      [Direction.up]= function() return Direction.down end,
      [Direction.down]= Direction.up,
      [Direction.forward]= Direction.back,
      [Direction.back]= Direction.forward,
    }
    result = switch[self.current]
    if result == nil then
      return "Invalid direction set"
    end
    if type(result) == "function" then
      return result()
    else
      return result
    end
  end

  return self
end
t = Direction.new("left")
print(t.current)
print(t.opposite())
t = Direction.new("up")
print(t.current)
print(t.opposite())
t = Direction.new("forward")
print(t.current)
print(t.opposite())



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
