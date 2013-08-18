modemside = "right"
master = 0
function checkModem()
    if (not rednet.isOpen(modemside)) then rednet.open(modemside) end
end

function detectMaster()
    checkModem()
    print("looking for master")
    if (master > 0 ) then return end
    rednet.broadcast("master!")
    while true do
        event, id, text = os.pullEvent()
        if event == "rednet_message" then
              if (string.match(text, "^yes!$")) then
                master = tonumber(id)
                print("master is: " .. master)
                break
              end
              if (string.match(text, "^update$")) then
                shell.run("update")
            end
        end
    end
end

local lastID = 0
detectMaster()

print("master is: " .. master)

clients = {
    pending = {}
}

while true do
  event, id, text = os.pullEvent()
  if event == "rednet_message" then

    print(text)
    if (string.match(text, "^master$")) then
        print("got a client as relay")
        rednet.send(id, "yes")
    elseif (string.match(text, "^getRess:%a+")) then
        print("sending " .. text  .. " to master")
        rednet.send(master, text)
    elseif (string.match(text, "^getResourceList$")) then
        print("sending " .. text  .. " to master")
        rednet.send(master, text)
    elseif (string.match(text, "^update$")) then
        shell.run("update")
    else
        print("sending " .. text .. " back to client:" .. lastID)
        rednet.send(tonumber(lastID), text)
    end
    if not (id == master) then
        lastID = id
        print("lastID:" .. lastID)
    end
  end
end


