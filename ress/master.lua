rednet.open("right")

slaves = {}

rednet.broadcast("newmaster")

while true do
  event, id, text = os.pullEvent()
  if event == "rednet_message" then
    if (string.match(text, "^registerSlave:%a+")) then
        material = string.sub(text, 15)
        slaves[material] = tonumber(id)
        rednet.send(slaves[material], "registered")
        print("registering " .. id  .. " as " .. material)
    end


    if (string.match(text, "^getRess:%a+")) then
        ress_type, amount = string.match(text, "^getRess:(%a+):(%d+)")
        print("type = " .. ress_type)
        print("amount = " .. amount)
        rec = slaves[ress_type]
        if rec == nil then
            print("we do not have " .. ress_type)
            rednet.send(id, "We currently do not have " .. amount .. " of this resoure: " .. ress_type)
        else
            print("sending " .. amount .. " of " .. ress_type)
            rednet.send(id, "Ordered ".. amount .. "x " .. ress_type)
            rednet.send(rec, ress_type .. ":" .. amount)
        end
    end

    if (string.match(text, "^master$")) then
        print("got a client")
        rednet.send(id, "yes")
    end
    if (string.match(text, "^master!$")) then
        print("got a client")
        rednet.send(id, "yes!")
    end
    if (string.match(text, "^getResourceList$")) then
        print("compile resource list")
        result = "Possible Resource: \n"
        for key,value in pairs(slaves) do
            result = result .. key .."\n"
        end
        rednet.send(id, result)
    end

    if (string.match(text, "^unregister:(%a+)")) then
        restype = string.match(text, "^unregister:(%a+)")
        slaves[restype] = nil
    end
    if (string.match(text, "^update$")) then
        shell.run("update")
    end
  end
end


