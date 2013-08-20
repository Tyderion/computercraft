-- Main Program taken from Computercraft mod

local upload_argument_name = "upload"
local install_argument_name = "install"
local update_argument_name = "update"
local program_name = "cpm"
local saveFileName = "listOfPrograms"
local installedPrograms = {}
local program_code = "wP9VAie2"




local function printUsage()
	print( "Usages:" )
	print( program_name .. " " .. install_argument_name .. " <code> <filename>" )
	print( program_name .. " " .. update_argument_name .. " [<filename>]" )
	print( program_name .. " " .. upload_argument_name .. " <filename>" )
end


local function loadInstalledPrograms()
	if fs.exists(saveFileName) then
		file = fs.open(saveFileName, "r")
		for line in file.readLine do
			for name,code in string.gmatch(line, "([^=]+)=([^=]+)") do
				if shell.resolveProgram(name) == nil then
					print(name .. " is not installed anymore")
				else
				  	installedPrograms[name] = code
				end
			end
		end
		file.close()
	end
	if installedPrograms[program_name] == nil then
		installedPrograms[program_name] = program_code
	end
end

local function saveInstalledPrograms()
	file = fs.open(saveFileName, "w")
	for name, code in pairs(installedPrograms) do
		file.writeLine(name.."="..code)
	end
	file.close()
end

local function saveNewProgram(name, code, text)
	installedPrograms[name] = code
	local path = shell.resolve( name )
	if not fs.exists(path) then
		local file = fs.open( path, "w" )
		file.write( text )
		file.close()
	end
end

local function upload(sFile)
	-- Upload a file to pastebin.com
	local sPath = shell.resolve( sFile )
	-- Determine file to upload
	if not fs.exists( sPath ) or fs.isDir( sPath ) then
		print( "No such file" )
		return
	end

	-- Read in the file
	local sName = fs.getName( sPath )
	local file = fs.open( sPath, "r" )
	local sText = file.readAll()
	file.close()

	-- POST the contents to pastebin
	write( "Connecting to pastebin.com... " )
	local key = "0ec2eb25b6166c0c27a394ae118ad829"
	local response = http.post(
		"http://pastebin.com/api/api_post.php",
		"api_option=paste&"..
		"api_dev_key="..key.."&"..
		"api_paste_format=lua&"..
		"api_paste_name="..textutils.urlEncode(sName).."&"..
		"api_paste_code="..textutils.urlEncode(sText)
		)

	if response then
		print( "Success." )

		local sResponse = response.readAll()
		response.close()

		local sCode = string.match( sResponse, "[^/]+$" )
		print( "Uploaded as "..sResponse )
		print( "Run \"pastebin get "..sCode.."\" to download anywhere" )
		saveNewProgram(sFile, sCode, sText)
	else
		print( "Failed." )
	end
end

local function install(code, name, output)
	-- Download a file from pastebin.com
	-- Determine file to download

	local path = shell.resolve( name )
	if fs.exists( path ) then
		print( "File already exists" )
		return false
	end

	-- GET the contents from pastebin
	if not (output == nil) then
		print( output.download )
	end
	local response = http.get(
		"http://pastebin.com/raw.php?i="..textutils.urlEncode( code )
		)

	if response then
		local text = response.readAll()
		response.close()
		saveNewProgram(name, code, text)
		if not (output == nil) then
			if not (output.saved == nil) then
				print( output.saved )
			end
		end
		return true

	else
		if not (output == nil) then
			print( output.failed )
		end
		return false
	end
end

local function update(program)
	local code = installedPrograms[program]
	if code == nil then
		print("program '" .. program .. "' is not installed.")
	else
		local movedname = "tmpMove" .. program
		shell.run("mv " .. program .. " " ..  movedname)
		local installOutput = {
			["download"] =  "Updating " .. program .. "...",
			["saved"] = nil,
			["failed"] = "Failed to download."
		}
		if install(code, program, installOutput) then
			shell.run("rm " .. movedname)
		end

	end
end

local function updateAllPrograms()
	for program,_ in pairs(installedPrograms) do

		update(program)
	end
end

local tArgs = { ... }

if not http then
	print( "Pastebin requires http API" )
	print( "Set enableAPI_http to 1 in mod_ComputerCraft.cfg" )
	return
end

loadInstalledPrograms()

local command = tArgs[1]
if command == upload_argument_name then
	if #tArgs < 2 then
		printUsage()
	  	return
	end
	local sFile = tArgs[2]
	upload(sFile)
elseif command == install_argument_name then
	if #tArgs < 3 then
		printUsage()
		return
	end
	local code = tArgs[2]
	local file = tArgs[3]
	local installOutput = {
		["download"] =  "Downloading '" .. code .. "' from pastebin...",
		["saved"] = "Saved as ".. name .. ".",
		["failed"] = "Failed to download."
	}
	install(code, file, installOutput)
elseif command == update_argument_name then
	if #tArgs < 2 then
		updateAllPrograms()
	else
		local program = tArgs[2]

		update(program)
	end
else
	printUsage()
	return
end

saveInstalledPrograms()

