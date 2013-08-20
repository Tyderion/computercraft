os.loadAPI("direction")

function line( length )
    local x = 0
    for i=1,length do
        dig()
        walk()
    end
end

function dig()
  while turtle.detect() do
    turtle.dig()
    sleep(0.4)
  end
end

function walk(length)
  local real_length = length or 1
  if turtle.getFuelLevel() < 10 then
    turtle.select(1)
    turtle.refuel()
  end
  for i=1,real_length do
    while  !turtle.forward() do end
  end
end

function rectangle( length, width )
    for width_counter=1, width do
        line(length)
        walkBack(length)
        if width_counter < tonumber(width) then
            turtle.turnLeft()
            dig()
            walk()
            turtle.turnRight()
        end
    end
end

function walkBack(length)
  for i=1,tonumber(length) do
    turtle.back()
  end
end

-- function fastRectangle( length, width, direction)
--   -- TODO: Use direction-class
--   if direction.value != Direction.left or direction.value != Direction.right then
--     print(direction.value .. " is no valid direction for rectangles")
--   end

--   for i=1,width do
--     line(length)
--     fastRectTurn(direction,i)
--   end
-- end

-- function fastRectTurn(direction, whichLine)
--   -- Alternates between turning the turtle left and right
--   -- depending on the direction it reverses the alteration
--   local compare = 0
--   if direction.value == Direction.left then
--     comparer = 0
--   elseif direction == Direction.right then
--     comparer = 1
--   end
--   if (whichLine % 2 == comparer) then
--     turtle.turnRight()
--   else
--     turtle.turnLeft()
--   end
-- end



