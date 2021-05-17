local isConsole = true 		-- assume running on a console/terminal until checked in initialise()
local isColoured= false 	-- assume not colour capable until checked in initialise()
local colors 	= {}
local sep 		= "~"
--[[ setup constants for the ANSI codes ]]
local escape 	= string.char(27)..'['
local BLACK 	= escape..'30m'
local WHITE 	= escape..'97m'
local GREY 		= escape..'37m'
local GRAY 		= escape..'37m'
local DGREY 	= escape..'90m'
local DGRAY 	= escape..'90m'
local BLUE 		= escape..'94m'
local GREEN 	= escape..'92m'
local CYAN 		= escape..'96m'
local RED 		= escape..'91m'
local MAGENTA 	= escape..'95m'
local YELLOW 	= escape..'93m'
local DBLUE 	= escape..'34m'
local DGREEN 	= escape..'32m'
local DCYAN 	= escape..'36m'
local DRED 		= escape..'31m'
local DMAGENTA 	= escape..'35m'
local DYELLOW 	= escape..'33m'

local BLACKBG 	= escape..'40m'
local WHITEBG 	= escape..'107m'
local GREYBG 	= escape..'47m'
local GRAYBG 	= escape..'47m'
local DGREYBG 	= escape..'100m'
local DGRAYBG 	= escape..'100m'
local BLUEBG 	= escape..'104m'
local GREENBG 	= escape..'102m'
local CYANBG 	= escape..'106m'
local REDBG 	= escape..'101m'
local MAGENTABG = escape..'105m'
local YELLOWBG 	= escape..'103m'
local DBLUEBG 	= escape..'44m'
local DGREENBG 	= escape..'42m'
local DCYANBG 	= escape..'46m'
local DREDBG 	= escape..'41m'
local DMAGENTABG= escape..'45m'
local DYELLOWBG = escape..'43m'

local RESET 	= escape..'0m'
local BRIGHT    = escape..'1m'
local DIM       = escape..'2m'
local UNDERLINE = escape..'4m'
local BLINK     = escape..'5m'
local REVERSE   = escape..'7m'
local HIDDEN    = escape..'8m'

local sSymbolsTop 		= {'┌', '─', '┐', '┬'}
local sSymbolsBottom 	= {'└', '─', '┘', '┴'}
local sSymbolsBody 		= {'│', ' ', '│', '│'}
local sSymbolsMid 		= {'├', '─', '┤', '┼'}

local dSymbolsTop 		= {'╔', '═', '╗', '╦'}
local dSymbolsBottom 	= {'╚', '═', '╝', '╩'}
local dSymbolsBody 		= {'║', ' ', '║', '║'}
local dSymbolsMid 		= {'╠', '═', '╣', '╬'}

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

local function GetEnvironment() 
	local cpath = package.cpath
	local ide = ""
	if GetOS() == 'nt' then
		if cpath:find('ZeroBrane') ~= nil then
			ide = "ZeroBraneStudio"
		elseif cpath:find('\\Lua') ~= nil or cpath:find('\\lua') ~= nil then
			ide = 'cmd'
		elseif cpath:find(';') == nil then
			ide = 'vscode'
		end
	else
		if cpath:find('zbstudio') ~= nil then
			ide = "ZeroBraneStudio"
		else
			ide = "terminal"
		end
	end
	
	return ide
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

function string:Split(sSeparator, nMax, bRegexp, noEmpty)
	--[[use: tblSplit = SplitTest:Split('~',[nil], [nil], false) or tblSplit = string.Split(SplitTest, '~')]]   
	assert(sSeparator ~= '','separator must not be empty string')
	assert(nMax == nil or nMax >= 1, 'nMax must be >= 1 and not nil')
	if noEmpty == nil then noEmpty = true end

	local aRecord = {}
	local newRecord = {}

	if self:len() > 0 then
		local bPlain = not bRegexp
		nMax = nMax or -1

		local nField, nStart = 1, 1
		local nFirst,nLast = self:find(sSeparator, nStart, bPlain)
		while nFirst and nMax ~= 0 do
			aRecord[nField] = self:sub(nStart, nFirst-1)
			nField = nField+1
			nStart = nLast+1
			nFirst,nLast = self:find(sSeparator, nStart, bPlain)
			nMax = nMax-1
		end
		aRecord[nField] = self:sub(nStart)
		
		if noEmpty then --split on newline preserves empty values
			for i = 1, #aRecord do
				if aRecord[i] ~= "" then
					table.insert(newRecord, aRecord[i])
				end
			end
		else
			newRecord = aRecord
		end
	end
	
	return newRecord
end

local function Initialise()
	--[[colours have been divided into bright with no qualifier and dark with D ]]
	colors.BLACK 		= BLACK
	colors.WHITE 		= WHITE
	colors.GREY 		= GREY
	colors.GRAY 		= GRAY
	colors.DGREY 		= DGREY
	colors.DGRAY 		= DGRAY
	colors.BLUE 		= BLUE
	colors.GREEN 		= GREEN
	colors.RED 			= RED
	colors.MAGENTA 		= MAGENTA
	colors.YELLOW 		= YELLOW
	colors.DBLUE 		= DBLUE
	colors.DGREEN 		= DGREEN
	colors.DCYAN 		= DCYAN
	colors.DRED 		= DRED
	colors.DMAGENTA 	= DMAGENTA
	colors.DYELLOW 		= DYELLOW
	
	colors.BLACKBG 	 	= BLACKBG
	colors.WHITEBG 	 	= WHITEBG
	colors.GREYBG 		= GREYBG
	colors.GRAYBG 		= GRAYBG
	colors.DGREYBG 		= DGREYBG
	colors.DGRAYBG 		= DGRAYBG
	colors.BLUEBG 		= BLUEBG
	colors.GREENBG 		= GREENBG
	colors.CYANBG 		= CYANBG
	colors.REDBG 		= REDBG
	colors.MAGENTABG 	= MAGENTABG
	colors.YELLOWBG 	= YELLOWBG
	colors.DBLUEBG 		= DBLUEBG
	colors.DGREENBG 	= DGREENBG
	colors.DCYANBG 		= DCYANBG
	colors.DREDBG 		= DREDBG
	colors.DMAGENTABG 	= DMAGENTABG
	colors.DYELLOWBG 	= DYELLOWBG
	
	colors.RESET 		= RESET
	colors.BRIGHT     	= BRIGHT
	colors.DIM        	= DIM
	colors.UNDERLINE  	= UNDERLINE
	colors.BLINK      	= BLINK
	colors.REVERSE    	= REVERSE
	colors.HIDDEN     	= HIDDEN
	
	local environment = GetEnvironment()
	if environment ~= "cmd" and environment ~= "terminal" then
		isConsole = false
	else
		isColoured = true
	end
end

local function utf8length(str)
	--[[ local length = text:utf8len() ]]
	local asciiLength = 0
	local utf8length = 0
	for i = 1, #str do
		if string.byte(str:sub(i,i)) < 128 then
			asciiLength = asciiLength + 1
		else
			utf8length = utf8length + 1
		end
	end
	if utf8length > 0 then
		utf8length = utf8length / 3
	end
	
	return asciiLength + utf8length
end
string.utf8len = utf8length

local function lpad(text, length, char)
	--[[Pads str to length len with char from right
		test = test:lpad(8, ' ') or test = string.lpad(test, 8, ' ')]]
	if char == nil then char = ' ' end
	local padding = ''
	local textlength = text:utf8len()
	for i = 1, length - textlength do
		padding = padding..char
	end
	return text..padding
end
string.lpad = lpad -- adds additional function to the string library
string.PadRight = lpad

local function RemoveANSI(text)
	-- text = "Hello..RED..World" = "Hello`[91m World" where ` represents Char(27)
	local retValue = ''
	local start = text:find(string.char(27))
	while start ~= nil do						-- start = 6
		retValue = retValue..text:sub(1, start - 1) -- "Hello"
		text = text:sub(start)					-- "`[91m World"
		start = text:find('m') 				-- 5
		text = text:sub(start + 1)					-- " World"
		start = text:find(string.char(27))		-- nil: end loop
	end
	return retValue
end	

local function ColorPrint(value, newline, reset)
	--[[ If running from Zeobrane or other IDE isColoured = false: ignore colour tags]]
	if newline == nil then newline = true end
	if reset == nil then reset = true end
	--[[
		This uses the default char ~ to separate colour strings                
		change the line:  sep = "~" as required                 				
		other possibles are ` (backtick) ¬ (?) any character you will not use  
		example value = "~red~This is a line of red text"
	]]              
	numLines = 0
	if value:find(sep) ~= nil then -- text has colour tags in it
		lineParts = value:Split(sep)
		for i = 1, #lineParts do
			part = lineParts[i]
			if colors[part:upper()]~= nil then-- is 'red' / 'RED' in the colorsOut dictionary?
				if isColoured then
					io.write(colors[part:upper()])
				end
			else -- not a colour command so print it out without newline
				if part:find("\n") ~= nil then
					numLines = numLines + 1
				end
				io.write(part)
			end
		end
	elseif value:find(string.char(27)) ~= nil then
		-- string is in form of "Hello..RED..World"
		-- can be printed directly if isColoured
		if not isColoured or not isConsole then
			-- remove colour tags
			value = RemoveANSI(value)
		end
		io.write(value)
	else -- no colour tags in the text
		io.write(value)
	end
	if reset and isColoured then
		io.write(colors.RESET)
	end
	if newline then
		io.write("\n")    -- Add newline to complete the print command
		numLines = numLines + 1
	end
	
	return numLines
end

function main()
	--[[ Windows 10 1909 and above: enable UTF8 and ANSI code in CMD and Powershell:
	https://stackoverflow.com/questions/57131654/using-utf-8-encoding-chcp-65001-in-command-prompt-windows-powershell-window/57134096#57134096
	Windows 10 users you MUST either Clear() or Resize() to enable ANSI codes in a Lua script every time it is run ]]
	
	Initialise()
	Resize(80, 25)
	Clear()
	
	ColorPrint(GREEN..dSymbolsTop[1]..(""):PadRight(78, dSymbolsTop[2])..dSymbolsTop[3])
	ColorPrint(GREEN..dSymbolsBody[1]..(""):PadRight(78, dSymbolsBody[2])..dSymbolsBody[3])
	ColorPrint(GREEN..dSymbolsMid[1]..(""):PadRight(78, dSymbolsMid[2])..dSymbolsMid[3])
	ColorPrint(GREEN..dSymbolsBody[1]..(""):PadRight(78, dSymbolsBody[2])..dSymbolsBody[3])
	ColorPrint(GREEN..dSymbolsBottom[1]..(""):PadRight(78, dSymbolsBottom[2])..dSymbolsBottom[3])
	io.write("Enter to continue")
	io.read()
end

main()