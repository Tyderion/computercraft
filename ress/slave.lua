rednet.open("top")
left = "dirt"
front = "planks"
right = "logs"
config = {
}
registered = false

pulseLengthInSec = 1.5

local currentText = ""


configured = 0


function loadConfig()
  if fs.exists("slave.cfg") then
    file = fs.open("slave.cfg", "r")
    while true do
      local line = file.readLine()
      if string.match(line, "^left:%a+") then
        left = string.match(line, "^left:(%a+)")
        config[left] = "left"
        configured = configured + 1
      end
      if string.match(line, "^front:%a+") then
        front = string.match(line, "^front:(%a+)")
        config[front] = "back"
        configured = configured + 1
      end
      if string.match(line, "^right:%a+") then
        right = string.match(line, "^right:(%a+)")
        config[right] = "right"
        configured = configured + 1
      end
      if configured == 3 then
        break
      end
    end
    file.close()
    print("loaded config:")
    print("left: " .. left)
    print("back: " .. front)
    print("right: " .. right)
  end
end


loadConfig()

function checkUpdate()
  if (string.match(text, "^update$")) then
    shell.run("update")
  end
end

function register()

  broadcast = function()
    rednet.broadcast("registerSlave:".. left)
    rednet.broadcast("registerSlave:".. front)
    rednet.broadcast("registerSlave:".. right)
  end
  print("registering")
  broadcast()
  print("waiting for answer")
  count = 0
  while true do
    count = count + 1
    event, id, text = os.pullEvent()
    if event == "rednet_message" then
      if (string.match(text, "^registered$")) then
        master = tonumber(id)
        registered = true
        print("registered")
        break
      end
      if (string.match(text, "^newmaster$")) then
        broadcast()
      end
      checkUpdate()
    end
  end
  run()
end


function checkAndSendRess(ress)
 if (id == master and string.match(currentText, "^" .. ress .. ":%d+$")) then
        amount = string.match(currentText,  "^" .. ress .. ":(%d+)$")
        print( "sending " .. amount .. " of " .. ress)
        rednet.send(master, "sending " .. amount .. " of " .. ress)
        for i=1,tonumber(amount) do
          giveStack(ress)
          sleep(0.2)
        end
end
end

function run()
  while true do
  event, id, text = os.pullEvent()
  currentText = text
    if event == "rednet_message" then
      if (string.match(text, "^newmaster$")) then
        break
      end
      checkAndSendRess(left)
      checkAndSendRess(front)
      checkAndSendRess(right)
      checkUpdate()
    end
  end
  register()
end

function giveStack(ress)
  direction = config[ress]
  print("ress: "  .. ress)
  print(direction)
  redstone.setOutput(direction, true)
  sleep(pulseLengthInSec)
  redstone.setOutput(direction, false)
end

register()






