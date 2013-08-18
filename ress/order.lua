os.unloadAPI("client")
os.loadAPI("client")
local args = { ... }

if #args < 1 then
    print("--- Welcome to Order v0.1 ---")
    print("type 'order list' to see list of available resources")
    print("type 'order resource 1' to get about 1 stack of resource if available")
    return
end
ress = args[1]
amount = 1
if #args >= 2 then
   amount = args[2]
end

if args[1] == "list" then
    client.listResources()
else
    client.order(ress, amount)
end


