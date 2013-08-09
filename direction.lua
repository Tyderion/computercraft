--os.loadAPI('api/switch')
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
    local switcher = switch.create(
    {
      ["cases"] = {
        [Direction.left] = Direction.right,
        [Direction.right]= Direction.left,
        [Direction.up]= Direction.down,
        [Direction.down]= Direction.up,
        [Direction.forward]= Direction.back,
        [Direction.back]= Direction.forward
      },
      ["default"] = ""
    }
    )
    return switcher(self.current)
  end

  return self
end
t = Direction.new("left")
print(t.current .. " is opposite of " .. t.opposite())
t = Direction.new("up")
print(t.current .. " is opposite of " .. t.opposite())
t = Direction.new("forward")
print(t.current .. " is opposite of " .. t.opposite())
