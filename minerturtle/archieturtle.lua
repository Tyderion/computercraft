local width=4
local tunnelLength=40
local torches=true
local torchesAvailable=true
local torches_step=10
local realTorches_step=7
local number_of_twin_tunnels=2
-- TODO
-- 1. Detect non-existing blocks underneath and place one
-- 2. Fix torch placement
-- further: detect lava/nothing on the sides?

function calculateTorchInterval(length,step)
  local numberOfTorches = math.floor(length/step)
  local step = math.floor(length/(numberOfTorches+1))
  print("Step: " .. step)
  return  step
end

function placeIfEmpty()
  if not turtle.detect() then
    turtle.place()
  end
end

function reverseSight()
  turtle.turnRight()
  turtle.turnRight()
end

function placeDownIfEmpty()
  if not turtle.detectDown() then
    turtle.placeDown()
  end
end


function placeUpIfEmpty()
  if not turtle.detectUp() then
    turtle.placeUp()
  end
end


function detectAndPlaceWallsIfNeeded()
  if turtle.getItemCount(3) < 5 then return false end
  turtle.select(3)
  turtle.turnLeft()
  placeIfEmpty()
  turtle.down()
  placeIfEmpty()
  turtle.select(4)
  placeDownIfEmpty()
  turtle.select(3)
  reverseSight()
  placeIfEmpty()
  turtle.up()
  placeIfEmpty()
  turtle.turnLeft()
  placeUpIfEmpty()
  return true
end



function smallTunnel(length, placeTorches)
  refuel(length)
  if not placeTorches then placeTorches = false end
  if placeTorches then
    print("Placing torch at beginning")
    placetorchDownIfAvailable()
  end
  for j=1,length,1 do
    refuel(10)
    digReallyForward()
    turtle.forward()
    turtle.digDown()
    print("j = " .. j)
    if j <= length then
      if not detectAndPlaceWallsIfNeeded() then
        for i=1,j,1 do
          turtle.back()
        end
        return
      end
    end
    if (j)%realTorches_step == 0 then
      print("placing torch because j = " .. j)
      if placeTorches then
        placetorchDownIfAvailable()
      end
    end
  end
end

function digReallyForward()

  while turtle.detect() do
    turtle.dig()
  end

end

function doSide()
  smallTunnel(4, false)
  if torchesAvailable then
    placetorchDownIfAvailable()
  end
  smallTunnel(4, false)
  -- detect if it's open, if it is, close it
  turtle.select(3)
  if turtle.detect() then
    turtle.place()
  end
  turtle.down()
  if turtle.detect() then
    turtle.place()
  end
  turtle.up()

  for i=1,4,1 do
    turtle.back()
  end
end

function doTwoLines()
  smallTunnel(tunnelLength, true)
  turtle.turnRight()
  doSide()
  turtle.turnRight()
  smallTunnel(tunnelLength, true)
  turtle.turnLeft()
  doSide()
  turtle.turnLeft()
end

function placetorchDownIfAvailable() -- Place a torch
        if turtle.getItemCount(2) == 0 then
            torchesAvailable= false
        else
            turtle.select(2)
            turtle.placeDown()
        end
end

function refuel(length)
   if not length then length = 1 end
   local level = turtle.getFuelLevel()
   print("Fuel level")
   print(level)
   if level < length then
    print("refueling")
    turtle.select(1)
    turtle.refuel(1)
   end
end



refuel()
if turtle.detectDown() then
  print("moving up")
  turtle.up()
end
-- print("torches_step: " .. torches_step)
-- print("length: " .. tunnelLength)
realTorches_step = calculateTorchInterval(tunnelLength,torches_step)

print("Welcome to Archies Miner Bot")
print(" -------------------------- ")
print(" Please put coal in the first slot")
print(" Please put torches in the second slot")
print(" Please put glass for the walls in the third slot")
print(" Please put cobblestone for the floor in the fourth slot")
print(" type anything + enter to continue ")
local input = read()

for i=1,number_of_twin_tunnels,1 do
  doTwoLines()
end
