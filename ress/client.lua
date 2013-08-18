local modemside = "right"
local dirt = "dirt"
local registered = false

local master = 0

function checkModem()
    if (not rednet.isOpen(modemside)) then rednet.open(modemside) end
end


function detectMaster()
    checkModem()
    if (master > 0 ) then return end
    rednet.broadcast("master")
    while true do
        event, id, text = os.pullEvent()
        if event == "rednet_message" then
              if (string.match(text, "^yes$")) then
                master = tonumber(id)
                break
              end
        end

    end
end

function listResources()
    detectMaster()
    rednet.send(master, "getResourceList")
     while true do
        event, id, text = os.pullEvent()
        if id == master and event == "rednet_message" then
            print(text)
            break
        end
    end
end


function order(what, amount)
    detectMaster()
    rednet.send(master, "getRess:" .. what .. ":" .. amount)
    while true do
        event, id, text = os.pullEvent()
        if id == master and event == "rednet_message" then
            print(text)
            break
        end

    end
end


local args = { ... }

--if #args < 1 then
    --print("---- Welcome to Ress-Get Client v0.1 ---")
    --print("----             Syntax              ---")
    --print(" --     Ordering     --")
    --print(" -- client order what amount")
    --print("---- or import client as an API in your script")
--end

if args[1] == "order" then
    if #args < 3 then
        print("Syntax: client order What Amount")
    else
        order(args[2], args[3])
    end
end
if args[1] == "list" then
    listResources()
end






