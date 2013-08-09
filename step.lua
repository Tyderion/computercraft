local left = "left"
local right = "right"
local forward = "forward"
local back = "back"
local up = "up"
local down = "down"
local reverse = false

function turn(direction)
    if direction == "left" then
        turtle.turnLeft()
    elseif direction == "right" then
        turtle.turnRight()
    elseif direction == "back" then
        reverse = true
    end
end

function walk(steps, reverse)
    if reverse == nil then reverse = false end
    if turtle.getFuelLevel() < tonumber(steps) then
        turtle.select(1)
        turtle.refuel(1)
    end
   for i=1,steps,1 do
        if reverse then
            turtle.back()
        else
            turtle.forward()
        end
    end
end

function isValidDirection(dir)
    return dir == left or dir == right or dir == forward or dir == back or dir == up or dir == down
end

local tArgs = { ... }

local direction = tArgs[1] or "forward"
if not isValidDirection(tArgs[1]) then
    direction = "forward"
end
local numberOfsteps = tArgs[2] or 1
if direction == up or direction == down then
    for i=1,numberOfsteps, 1 do
        if direction == up then
            turtle.up()
        else
            turtle.down()
        end
    end
else
    turn(direction)
    walk(numberOfsteps, reverse)
end


function inTable(table, thing)
    for _,entry in ipairs(table) do
        if entry == thing then return entry end
    end
    return nil
end
