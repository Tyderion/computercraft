-- taken from: http://pastebin.com/a0GF0qyu
local function parseArgs(...)
  local str=table.concat({...}," ")
  local args={}
  local flags={}

  local function grabQuoted(str)
    --first char is known "
    local skipNext=false
    local i=2
    while true and i<=#str do
      ch=string.sub(str,i,i)
      if ch=="\\" then
        i=i+1
      elseif ch=="\"" then
        --end
        return string.sub(str,2,i-1), string.sub(str,i+1,#str)
      end
      i=i+1
    end
    error("Invalid args: unterminated string!")
  end

  --strip whitespace
  while str and #str>0 do
    str=string.match(str,"%s*(.*)")
    local ch=string.sub(str,1,1)
    if ch=="-" then
      --flag
      local flag,eq,farg, rest
      flag,eq,rest=string.match(str,"-(%w)(=?)(.*)")
      farg=""
      if not flag then
        error("invalid arguments!")
      end
      if eq~="" then
        --there'll be a parameter
        if string.sub(rest,1,1)=="\"" then
          farg,rest=grabQuoted(rest)
        else
          farg,rest=string.match(rest,"(%S+)%s*(.*)")
        end
      end
      flags[flag]=farg
      str=rest
    elseif ch=="\"" then
      --literal string
      args[#args+1],str=grabQuoted(str)
    else
      --regular param
      args[#args+1],str = string.match(str,"(%S+)%s*(.*)")
    end
  end

  return args, flags
end

--calling it will return the parsed out args+flags
local args, flags=parseArgs(...)

--displaying them, for testing purposes
print("args:")
for i=1,#args do
  print(i..":"..args[i])
end

print("flags:")
for k,v in pairs(flags) do
  print(k..(v=="" and "" or "="..v))
end

--[[ Examples:
(assuming this is saved as "testargs")

>testargs arg1 -a -b="foo bar" "argument 2" -x=dave

output:
args:
1: arg1
2: argument 2
flags:
a
x=dave
b=foo bar

--]]
