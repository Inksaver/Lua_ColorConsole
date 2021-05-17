-- create ANSI constants
local escape 	= string.char(27)..'['

local WHITE 	= escape..'97m'
local RED 		= escape..'91m'
local GREEN 	= escape..'92m'
local BLACKBG 	= escape..'40m'
local WHITEBG 	= escape..'107m'
local RESET 	= escape..'0m'

local function GetOS()
	-- get os type: nt = Windows
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

local function Resize(cols, rows)
	-- set console size
	if GetOS() == 'nt' then
		os.execute("mode ".. cols ..",".. rows)
	else
		local cmd = "'\\e[8;".. cols ..";".. rows .."t'"
		os.execute("echo -e "..cmd)
	end
end

function main()
	--[[ Windows 10 1909 and above: enable UTF8 and ANSI code in CMD and Powershell:
	https://stackoverflow.com/questions/57131654/using-utf-8-encoding-chcp-65001-in-command-prompt-windows-powershell-window/57134096#57134096
	Windows 10 users you MUST either Clear() or Resize() to enable ANSI codes in Lua scripts every time it is run ]]
	Resize(80, 5)
	Clear()
	print("Hello "..RED.."Coloured "..GREEN.."World"..RESET)
	io.write("Enter to continue")
	io.read()
end
main()