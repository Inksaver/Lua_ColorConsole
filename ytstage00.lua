local function GetOS()
	local cpath = package.cpath
	local OS = ""
	if cpath:find('\\') == nil then
		OS = 'posix'
	else
		OS = 'nt'
	end
	return OS
end

local function Clear()
	--clear screen
	if GetOS() == 'nt' then
		os.execute("cls")
	else
		os.execute("clear")
	end
end

local function main()
	--[[ Windows 10 1909 and above: enable UTF8 and ANSI code in CMD and Powershell:
	https://stackoverflow.com/questions/57131654/using-utf-8-encoding-chcp-65001-in-command-prompt-windows-powershell-window/57134096#57134096 ]]
	os.execute("cls")
	print("Hello "..string.char(27)..'[91m'.."Coloured "..string.char(27)..'[92m'.."World"..string.char(27)..'[0m')
	io.write("Enter to continue")
	io.read()
end

main()