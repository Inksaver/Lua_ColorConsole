local ui 		= {}
local colors 	= {}
local constColors = {}
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

local black 	= sep..'BLACK'..sep
local grey      = sep.."GREY"..sep;
local gray      = sep.."GREY"..sep;
local dgrey     = sep.."DGREY"..sep;
local dgray     = sep.."DGREY"..sep;
local white     = sep.."WHITE"..sep;
local blue      = sep.."BLUE"..sep;
local green     = sep.."GREEN"..sep;
local cyan      = sep.."CYAN"..sep;
local red       = sep.."RED"..sep;
local magenta   = sep.."MAGENTA"..sep;
local yellow    = sep.."YELLOW"..sep;
local dblue     = sep.."DBLUE"..sep;
local dgreen    = sep.."DGREEN"..sep;
local dcyan     = sep.."DCYAN"..sep;
local dred      = sep.."DRED"..sep;
local dmagenta  = sep.."DMAGENTA"..sep;
local dyellow   = sep.."DYELLOW"..sep;
local blackbg   = sep.."BLACKBG"..sep;
local greybg    = sep.."GREYBG"..sep;
local graybg    = sep.."GREYBG"..sep;
local dgreybg   = sep.."DGREYBG"..sep;
local dgraybg   = sep.."DGRAYBG"..sep;
local whitebg   = sep.."WHITEBG"..sep;
local bluebg    = sep.."BLUEBG"..sep;
local greenbg   = sep.."GREENBG"..sep;
local cyanbg    = sep.."CYANBG"..sep;
local redbg     = sep.."REDBG"..sep;
local magentabg = sep.."MAGENTABG"..sep;
local yellowbg  = sep.."YELLOBGW"..sep;
local dbluebg   = sep.."DBLUEBG"..sep;
local dgreenbg  = sep.."DGREENBG"..sep;
local dcyanbg   = sep.."DCYANBG"..sep;
local dredbg    = sep.."DREDBG"..sep;
local dmagentabg= sep.."DMAGENTABG"..sep;
local dyellowbg = sep.."DYELLOWBG"..sep;
local reset     = sep.."RESET"..sep;

local osName 		= ''
local isConsole 	= true 		-- assume running on a console/terminal until checked in initialise()
local isColoured 	= false 	-- assume not colour capable until checked in initialise()
local windowWidth 	= 80		-- default console width
local windowHeight 	= 25		-- default console height

local sSymbolsTop 		= {'┌', '─', '┐', '┬'}
local sSymbolsBottom 	= {'└', '─', '┘', '┴'}
local sSymbolsBody 		= {'│', ' ', '│', '│'}
local sSymbolsMid 		= {'├', '─', '┤', '┼'}

local dSymbolsTop 		= {'╔', '═', '╗', '╦'}
local dSymbolsBottom 	= {'╚', '═', '╝', '╩'}
local dSymbolsBody 		= {'║', ' ', '║', '║'}
local dSymbolsMid 		= {'╠', '═', '╣', '╬'}

local dictSingle = {
	top 	= sSymbolsTop,
	body   	= sSymbolsBody,
	mid    	= sSymbolsMid,
	bottom 	= sSymbolsBottom
}

local dictDouble = {
	top    = dSymbolsTop,
	body   = dSymbolsBody,
	mid    = dSymbolsMid,
	bottom = dSymbolsBottom
}

function ClearTable(tbl)
	if tbl ~= nil then
		for k in pairs (tbl) do
			tbl[k] = nil
		end
	end
	return tbl
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
local function rpad(text, length, char)
	--[[Pads str to length len with char from left]]
	if char == nil then char = ' ' end
	local padding = ''
	local textlength = text:utf8len()
	for i = 1, length - textlength do
		padding = padding..char
	end
	return padding..text
end
string.rpad = rpad -- adds additional function to the string library
string.PadLeft = rpad
local function Trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end
string.Trim = Trim
string.Strip = Trim
local function TrimEnd(s, char)
	if s:sub(#s,#s) == char then
		return s:sub(1, #s-1)
	else
		return s
	end
	--return (s:match( "(.-)%s*$" ))
end
string.TrimEnd = TrimEnd
local function TrimStart(s)
	return (s:match( "^%s*(.+)" ))
end
string.TrimStart = TrimStart
function string:Count(c)
    local _,n = self:gsub(c,"")
    return n
end

function string:EndsWith(ending)
	return ending == "" or self:sub(-#ending) == ending
end

function string:StartsWith(start)
	return self:sub(1, #start) == start
end

function string:Replace(old, new)
	--[[use: text = text:Replace('~', '') or text = string.Replace(text, '~', '')]]  
	return string.gsub(self, old, new)
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

function findLast(haystack, needle)
    if needle == '.' then
		needle = '%.' --escape the dot
	end
	local i=haystack:match(".*"..needle.."()")
    if i==nil then return nil else return i-1 end
end
string.findLast = findLast
string.LastIndexOf = findLast
function table.IsEmpty(tbl)
	local empty = true
	if next(tbl, nil) ~= nil then -- true if any items
		empty = false
	end
	return empty
end

local function tchelper(first, rest)
   return first:upper()..rest:lower()
end

local function BuildDescription(newLines, line, maxLength)
	--[[takes a list of lines , adds new lines up to maxLength and returns list]]
	while #line > maxLength do -- line length > 78 in 80 col terminal
		--python local ending = line[:maxLength].rfind(' ') -- break line from last space within the first 78 chars
		local substr = line:sub(1, maxLength)
		local lastSpacePos = substr:findLast(' ')
		substr = line:sub(1, lastSpacePos)
		table.insert(newLines, substr)
		line = line:sub(lastSpacePos + 1)
	end
	if #line > 0 then -- partial line
		table.insert(newLines, line)	
	end
	return newLines
end

local function GetOS()
	local cpath = package.cpath
	local retValue = ""
	if cpath:find('\\') == nil then
		retValue = 'posix'
	else
		retValue = 'nt'
	end
	return retValue
end

local function InList(data, value)
	-- look for '%{white}' in constColors
	local inList = false
	local pos = 0
	for i = 1, #data do
		if data[i] == value then
			inList = true
			pos = i
			break
		end
	end
	return inList, pos
end	

local function ValidateColors(foreColor, backColor)
	--[[ Fore and back colours checked if they exist in tables. Deals with %{white}, 'WhITe', '~whiTe~' ]]
	local modifiedForeColor, modifiedBackColor
	if InList(constColors, foreColor) then -- parameter supplied as '%{white}'
		modifiedForeColor = foreColor
	else
		modifiedForeColor = foreColor:upper() --"red" -> "RED" "~red~" -> "~RED~"
		modifiedForeColor = modifiedForeColor:Replace(sep, "") --remove separators
		assert(colors[modifiedForeColor] ~= nil,'foreground color '..foreColor..' not found in dictionary')
		modifiedForeColor = sep..modifiedForeColor..sep
	end
	if InList(constColors, backColor) then
		modifiedBackColor = backColor
	else
		modifiedBackColor = backColor:upper() --"red" -> "RED" "~redbg~" -> "~REDBG~"
		modifiedBackColor = modifiedBackColor:Replace(sep, "") --remove separators
		assert(colors[modifiedBackColor] ~= nil ,'background color '..backColor..' not found in dictionary')
		if modifiedBackColor:EndsWith("BG") then
			modifiedBackColor = sep..modifiedBackColor..sep
		else 
			modifiedBackColor = sep..modifiedBackColor..'BG'..sep
		end
	end
	return modifiedForeColor, modifiedBackColor 
end

local function InTable(data, value)
	-- look for 'green' in keys
	local inList = false
	for k,v in pairs(data) do
		if k == value then
			inList = true
			break
		end
	end
	return inList
end	

local function FixStyle(style)
	style = style:Trim():lower()
	if (style ~= "s" and style ~= "d") then
		style = "s"
	end
	return style
end

local function FormatColorTags(text)
	--[[ Checks supplied string has matching tags to define colour strings ]]
	local colorTagList = {}
	-- check if even numbers of tags
	assert(text:Count(sep) % 2 == 0, "The supplied text "..text.." does not have matching colour separators: "..sep)
	text = text:Replace(sep, "¶"..sep.."¶")
	local data = text:Split('¶')
	--local data = SplitClean(text, '¶'); --"~red~some text~green~more text" -> "¶~¶red¶~¶some text¶~¶green¶~¶more text"
											   -- {"~", "red", "~", "some text", "~","green", "~", "more text"}
	local colorTagSpaces = 0
	local startTag = -1
	local endTag = -1
	local colorData = -1
	for i =1, #data do
		if data[i] == sep then -- found ~
			colorTagSpaces = colorTagSpaces + 1
			if startTag == -1 then
				startTag = i
				colorData = i + 1
				endTag = i + 2
			elseif i == endTag then --marked already, next data is normal text
				colorData = -1;
			else -- i not -1 and not endTag
				startTag = i;
				colorData = i + 1;
				endTag = i + 2;
			end
		else
			if i == colorData then
				-- convert "~red~" to "~RED~"
				local textColor = data[i]:upper()
				if colors[textColor] ~= nil then
					--data[i] = colors[textColor]
					colorTagSpaces = colorTagSpaces + #data[i]
					--table.insert(colorTagList, colors[textColor]) -- inserts eg '%{white}'
					table.insert(colorTagList, sep..textColor..sep) -- inserts eg '~WHITE~'
				end
				colorData = -1
			end
		end
	end
	-- re-combine textLines
	local output = ''
	for i = 1, #data do
		--if data[i] ~= sep then output = output..data[i] end
		output = output..data[i]
	end
	
	return colorTagSpaces, output, colorTagList
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

local function PadString(text, width, padChar, align)
	--[[ width should be width of the part to be padded, so excludes left/right margin characters ]]
	align = align or 'left'
	local output = text
	local colorTagSpaces = 0
	if text:find(sep) ~= nil then -- colour tag(s) present
		colorTagSpaces, output, embeddedColors = FormatColorTags(output) --extract any colour info from output eg ~red~ returns additional spaces required and fomats output by ref
	end
	if align == "centre" or align == "center" then
		--output = output:PadLeft(((width - #output + colorTagSpaces) / 2) + #output, padChar);
		local uLength = output:utf8len()
		output = output:PadLeft((math.floor((width - uLength + colorTagSpaces) / 2)) + uLength, padChar) --eg output 10 chars long, pad to half of width - 2 and allow for chars used by colour tag
		output = output:PadRight(width + colorTagSpaces, padChar)
	elseif align == "right" then
		output = output:PadLeft(width + colorTagSpaces, padChar) -- right align = pad left
	else --left align = PadRight
		output = output:PadRight(width + colorTagSpaces, padChar)  --eg output 10 chars long, pad to width - 2 and allow for chars used by colour tag
	end
	
	return output
end

local function PadBoxSides(sides, body, boxAlign)
	local uLength = body:utf8len()
	sideLength = {0,0}
	sideLength[1] = string.utf8len(sides[1])
	sideLength[2] = string.utf8len(sides[2])
	if boxAlign == "left" then --pad rSide 
		local length = windowWidth - uLength - 2 -- 80 - 78 - 2 = 0
		if length > 0  then  sides[2] = PadString(sides[2], length, " ", "right") end    -- "║    "
	elseif boxAlign == "right" then--pad lSide 
		local length = windowWidth - uLength - 2; -- 80 - 78 - 1 = 1
		if length > 0 then sides[1] = PadString(sides[1], windowWidth - uLength - 1, " ", "left") end     -- "    ║"
	else -- centre
		local colorTagSpaces, output, embeddedColors = FormatColorTags(body) --extract any colour info from body eg ~red~);
		local length = windowWidth - uLength - 2 + colorTagSpaces -- 80 - 78 - 2 = 0
		if length >= 2 then
			sides[1] = PadString(sides[1], length / 2, " ", "right")
			--local sideText = sides[2]
			--local sideLength = sideText:utf8len() 
			sideLength[1] = string.utf8len(sides[1])
			length = windowWidth - uLength - sideLength[1] + colorTagSpaces
			if length > 0  then  sides[2] = PadString(sides[2], length, " ", "left") end
		end
	end

	return sides
end

local function Resize(windowWidth, windowHeight)
	if isConsole then
		if GetOS() == 'nt' then
			os.execute("mode "..windowWidth..","..windowHeight)
		else
			local cmd = "'\\e[8;"..windowHeight..";"..windowWidth.."t'"
			os.execute("echo -e "..cmd)
		end
		ui.Clear()
	end
end	

local function Sleep(s) 
    local sec = tonumber(os.clock() + s); 
    while (os.clock() < sec) do 
    end 
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
	colors.CYAN			= CYAN
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
	
	for _, v in pairs(colors) do -- make a list of color constants: {'%{black}','%{white}'}
		table.insert(constColors, v)
	end
	
	local environment = GetEnvironment()
	if environment ~= "cmd" and environment ~= "terminal" then
		isConsole = false
	else
		isColoured = true
	end
end


local function SelectCharacterList(part, style)
	--[[ select correct character list depending on style and part ]]
	local s = sSymbolsTop
	if part == "top" then                           -- 0 1 2 3 <- index
		s = sSymbolsTop                        		-- ┌ ─ ┐ ┬
		if style == "d" then s = dSymbolsTop end    -- ╔ ═ ╗ ╦
	elseif part == "mid" then 
		s = sSymbolsMid                        		-- ├ ─ ┤ ┼
		if style == "d" then s = dSymbolsMid end    -- ╠ ═ ╣ ╬
	elseif part == "bottom" then
		s = sSymbolsBottom                     		-- └ ─ ┘ ┴ 
		if style == "d" then s = dSymbolsBottom end -- ╚ ═ ╝ ╩
	elseif part == "body" then
		s = sSymbolsBody                     		-- └ ─ ┘ ┴ 
		if style == "d" then s = dSymbolsBody end   -- ╚ ═ ╝ ╩
	end
	
	return s
end

local function ValidateAlignment(align)
	--[[ check and correct align strings, else error ]]
	align = align:Trim():lower()
	local check = { "left", "centre", "center", "right" }
	assert(InList(check, align) == true, "Align parameter must be: 'left', 'centre', 'center', 'right'")
	return align
end

local function ValidateBoxPart(part)
	--[[ check and correct box part strings, else error ]]
	part = part:Trim():lower()
	local check = { "top", "mid", "bottom", "body" }
	assert(InList(check, part) == true,"Part parameter must be: 'top', 'mid', 'bottom', 'body'")
	return part
end

local function GetMaxLengthString(text, maxLength)
	--[[ get a substring of whole words up to max length ]]
	local colorTagSpaces, output, colorTagList = FormatColorTags(text)
	if #text > maxLength + colorTagSpaces then
		text = text:sub(1, maxLength + colorTagSpaces)
		local ending = text:LastIndexOf(" ")
		text = text:sub(1, ending)
	end
	return text:Trim()
end

local function GetFormattedLines(textLines, maxLength, noBorder)
	--[[takes a list of lines , checks length of each and adds additional lines if required, returns list]]
	-- check length of each line. max = windowWidth
	maxLength = maxLength or 0
	noBorder = noBorder or false
	if maxLength > windowWidth or maxLength <= 0 then maxLength = windowWidth end
	if not noBorder then maxLength = maxLength - 2 end  --default  80-2 = 78 chars 
	if type(textLines) ~= "table" then
		textLines = textLines:Split('\n', nil, nil, false)
	end
	local newLines = {}
	for index = 1, #textLines do
		local line = (textLines[index]):Trim()                  -- remove leading/trailing spaces
		local colorTagSpaces = 0
		-- now check the length of each line and cut into shorter sections if required
		if #line == 0 then  table.insert(newLines, line)               -- add empty
		else
			while #line >= maxLength + colorTagSpaces do  -- line length > 77 in 80 col terminal
				local text = GetMaxLengthString(line, maxLength)
				table.insert(newLines, text)
				line = line:sub(#text + 1):Trim()
			end
			if #line > 0 then table.insert(newLines, line) end            -- partial line left over from the while loop ( <maxLength) or short line
		end
	end

	return newLines, colorTagSpaces
end

local function GetLines(text)
	--[[format text string into  fixed length lines]]
	--[[
	example: (could contain \n characters, or continuous line)
	"You are in a hotel room\nsmelling of stale cigarettes (the room not you).
	You have just woken up after a night of heavy drinking, and you have no idea how you got here..."
	]]
	local textLines = {}
	if text:find('\\n') ~= nil then
		textLines = text:Split('\\n') -- if multiple lines 
	else
		textLines = text:Split('\n') -- if multiple lines 
	end
	-- check length of each line max = shared.windowWidth - 2
	local newLines = {} -- empty list for processing description
	local maxLength = windowWidth - 2
	for index = 1, #textLines do -- 2 lines in above as contains \n
		line = textLines[index]:trim() -- iteration 0: "You are in a hotel room" iteration 1: "smelling of stale cigarettes...etc
		newLines = BuildDescription(newLines, line, maxLength)
	end
	-- table of lines, each of which will fit into 78 cols
	
	return newLines
end

local function Input(prompt, ending, foreColor, backColor)
	--[[ Get keyboard input from user (requires Enter ) ]]
	prompt = prompt or 'Press Enter to continue'
	ending = ending or '>_'
	foreColor = foreColor or 'WHITE'
	backColor = backColor or 'BLACKBG'
	-- check if prompt contains embedded colours
	local colorTagSpaces, output, embeddedColors = FormatColorTags(prompt) -- extract any colour info from prompt eg ~red~
	for i = 1, #embeddedColors do
		if embeddedColors[i]:find("BG") ~= nil then backColor = embeddedColors[i] 
		else foreColor = embeddedColors[i] end
	end
	foreColor, backColor = ValidateColors(foreColor, backColor)
	ui.ColorPrint(foreColor..backColor..prompt..ending, false) --do not use newline
	return io.read()
end

local function ProcessInput(prompt, promptChar, textColor, backColor, min, max, dataType)
	if textColor == '' or textColor == nil then textColor = 'WHITE' end
	if backColor == '' or backColor == nil then backColor = 'BLACKBG' end
	local message = ''
	local valid = false
	local userInput = Input(prompt, promptChar, textColor, backColor)
	if #userInput == 0 and min > 0 then
		message = "Just pressing the Enter key doesn't work..."
	else
		if dataType == "str" or dataType == "string" then -- str or string
			if #userInput > max or #userInput < min then
				message = "Try entering a string between "..min.." and "..max.." characters"
			else
				valid = true
			end
		elseif dataType == "bool" then		
			if userInput:sub(1,1):lower() == "y" then
				userInput = true
				valid = true
			elseif userInput:sub(1,1):lower() == "n" then
				userInput = false
				valid = true
			else
				message = 'Only anything starting with y or n is accepted...'
			end
		else -- int or real number
			local convert = nil
			if dataType == "int" or dataType == 'float' then
				convert = tonumber(userInput)	
			end
			if convert ~= nil then --number entered
				if convert >= min and convert <= max then
					--check for int
					if dataType == 'int' then
						if convert ~= math.floor(convert) then
							message = "Try entering a whole number "..convert.." is not an integer"
						else
							valid = true
							userInput = convert
						end
					else
						valid = true
						userInput = convert
					end
				else
					message = 'Try a number from '..min..' to '..max..'...'
				end
			else
				message = 'Try entering a number - '.. userInput..' does not cut it...'
			end
		end
	end		
	return valid, userInput, message
end

local function ToTitle(Text) --converts any string to Title Case
	return Text:gsub("(%a)([%w_']*)", tchelper)
end

local function GetBoolean(prompt, promptChar, textColor, backColor)
	textColor = textColor or 'WHITE'
	backColor = backColor or 'BLACKBG'
	valid, userInput, message =  ProcessInput(prompt, promptChar, textColor, backColor, 1, 3, "bool")
	return valid, userInput, message
end

local function GetRealNumber(prompt, promptChar, textColor, backColor, min, max)
	--[[ Public Method: gets an float from the user ]]
	textColor = textColor or 'WHITE'
	backColor = backColor or 'BLACKBG'
	min = min or -100000000.0
	max = max or 100000000.0
	valid, userInput, message =  ProcessInput(prompt, promptChar, textColor, backColor, min, max, "float")		
	return valid, userInput, message
end

local function GetInteger(prompt, promptChar, textColor, backColor, min, max) -- min and max can be over-ridden by calling code
	--[[ Public Method: gets an integer from the user ]]
	textColor = textColor or 'WHITE'
	backColor = backColor or 'BLACKBG'
	min = min or 0
	max = max or 65536
	valid, userInput, message =  ProcessInput(prompt, promptChar, textColor, backColor, min, max, "int")		
	return valid, userInput, message
end

local function GetString(prompt, promptChar, textColor, backColor, withTitle, min, max) -- with_title, min and max can be over-ridden by calling code
	--[[Public method: Gets a string from the user, with options for Title Case, length of the string. Set min to 0 to allow empty string return]]
	textColor = textColor or 'WHITE'
	backColor = backColor or 'BLACKBG'
	withTitle = withTitle or false
	min = min or 0
	max = max or 20
	valid, userInput, message =  ProcessInput(prompt, promptChar, textColor, backColor, min, max, "string")	
	
	if withTitle and valid then
		userInput = ToTitle(userInput)
	end	
	return valid, userInput, message
end

local function PrintLine(text, textColor, backColor)
	textColor = textColor or 'WHITE'
	backColor = backColor or 'BLACKBG'
	ui.ColorPrint(textColor..backColor..text)
end

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

local function Teletype(text, delay, foreColor, backColor)
	--This text prints out slowly
	foreColor = foreColor or WHITE
	backColor = backColor or BLACKBG
	ui.ColorPrint(foreColor..backColor,false, false)
	for i = 1, #text do
		io.write(text:sub(i, i))
		Sleep(delay)
	end
	ui.ColorPrint(RESET)
	return 1
end

function ui.AddLines(numLines, currentLines, foreColor, backColor) 
	foreColor = foreColor or white
	backColor = backColor or blackbg
	foreColor, backColor = ValidateColors(foreColor, backColor)
	local blank = string.lpad('', windowWidth, ' ')
	if currentLines == nil then
		if numLines > 0 then
			for i = 1, numLines do
				ui.ColorPrint(foreColor..backColor..blank, true)
			end
		end
	else
		local leaveLines = numLines
		numLines = windowHeight - currentLines - leaveLines
		if numLines > 0 then
			for i = 1, numLines do
				ui.ColorPrint(foreColor..backColor..blank, true)
			end
		end
	end
	return numLines
end	

function ui.Clear()
	if isConsole then
		if GetOS() == 'nt' then
			os.execute("cls")
		else
			os.execute("clear")
		end
	else
		ui.AddLines(25)
	end
end

function ui.Menu(style, title, promptChar, textLines, foreColor, backColor, align, width)
	-- displays a menu using the text in 'title', and a list of menu items (string)
	-- add numbers to the text lines and then pass to DrawColouredui.Menu()
	foreColor = foreColor or 'WHITE'
	backColor = backColor or 'BLACKBG'
	style = FixStyle(style)
	foreColor, backColor = ValidateColors(foreColor, backColor)
	align = align or 'left'
	width = width or 0
	if width > windowWidth or width <= 0 then
		width = windowWidth
	end
	local userInput = 0
	local valid = false
	local message = ''
	for i = 1, #textLines do
		if i < 10 then
			textLines[i] = "     "..i..' '..textLines[i]
		else
            textLines[i] = "    "..i..' '..textLines[i]
		end
	end
	while not valid do
		ui.Clear()
		local numLines = 0
		numLines = numLines + ui.DrawBoxOutline(style, "top", foreColor, backColor)          -- draw top of box double line
		numLines = numLines + ui.DrawBoxBody(style, "", "centre", foreColor, backColor)       -- draw empty line
		numLines = numLines + ui.DrawBoxBody(style, title, "left", foreColor, backColor) 		-- draw title
		numLines = numLines + ui.DrawBoxBody(style, "", "centre", foreColor, backColor)       -- draw empty line
		for i = 1, #textLines do
			numLines = numLines + ui.DrawBoxBody(style, textLines[i], "left", foreColor, backColor) -- draw menu options
		end
		numLines = numLines + ui.DrawBoxBody(style, "", "centre", foreColor, backColor)       -- draw empty line
		numLines = numLines + ui.DrawBoxOutline(style, "bottom", foreColor, backColor)        -- draw top of box double line, yellow
		-- get multiple return variables using Tuple
		ui.AddLines(5, numLines)
		ui.DrawLine("d", WHITE, BLACKBG)
		-- prompt, promptChar, textColor, backColor, min, max
		valid, userInput, message = GetInteger("Type the number of your choice (1 to "..#textLines..")", promptChar, foreColor, backColor, 1, #textLines)
		if not valid then
			ui.ColorPrint(RED..message..MAGENTA.." retry in 2 secs...")
			Sleep(2)
		end
	end	
	return userInput
end

function ui.ColorPrint(value, newline, reset)
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
			if colors[part:upper()]~= nil then-- is 'red' / 'RED' in the colors dictionary?
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
		if reset and isColoured then
			io.write(colors.RESET)
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
	if newline then
		io.write("\n")    -- Add newline to complete the print command
		numLines = numLines + 1
	end
	
	return numLines
end

function ui.SetConsole(cols, rows, foreColor, backColor, initialise)
	initialise = initialise or false
	-- Windows colour codes
	local windows =
	{
		black = '0', blue = '1', green = '2', aqua = '3',
		red = '4', purple = '5', yellow = '6',  white = '7',
		grey = '8', lightblue = '9', lightgreen = 'A', lightaqua = 'B',
		lightred = 'C', lightpurple = 'D', lightyellow = 'E', brightwhite = 'F'
	}
	-- Linux termial colour codes
	local linuxFg =
	{
		black = '30', red = '31',  green = '32', yellow = '33',
		blue = '34', magenta = '35',  cyan = '36',  white = '37',
	}
	local linuxBg =
	{
		black = '40', red = '41',  green = '42', yellow = '43',
		blue = '44', magenta = '45',  cyan = '46',  white = '47'
	}
	windowWidth = cols
	windowHeight = rows
	Resize(windowWidth, windowHeight)
	-- change colours
	if isConsole then
		if GetOS() == 'nt' then
			os.execute("color "..windows[backColor]..windows[foreColor]) -- white on black preferred
		else
			local bc = "'\\e["..linuxBg[backColor].."m'"
			os.execute("echo -e "..bc)
			local fc = "'\\e["..'1'.."m'"
			os.execute("echo -e "..fc)
			fc = "'\\e["..linuxFg[foreColor].."m'"
			os.execute("echo -e "..fc)
		end
		ui.Clear()
	end
	if initialise then
		ui.DisplaySetup(cols, rows, foreColor, backColor)
	end
end

function ui.DisplayMessage(message, useInput, useTimer, foreColor, backColor, delay)
	foreColor = foreColor or 'WHITE'
	backColor = backColor or 'BLACKBG'
	delay = delay or 2
	foreColor, backColor = ValidateColors(foreColor, backColor)

	if useTimer then
		if type(message) == 'string' then
			if message ~= '' then
				ui.ColorPrint(foreColor..backColor..message)
				Sleep(delay)
			end
		else --list of messages
			if #message > 0 then
				for i = 1, #message do
					ui.ColorPrint(foreColor..backColor..message[i])
				end
			end
			Sleep(delay)
		end
		-- do not put Sleep(delay) here as empty message should have no delay
	end
	if useInput then
		if type(message) == 'string' then
			if message == '' then
				message =  "Press Enter to continue"
			else
				message = foreColor..backColor..message
			end
			Input(message, '...', 'WHITE', 'BLACKBG')
		else
			if #message > 0 then
				for i = 1, #message do
					ColorPrint(foreColor..backColor..message[i])
				end
			end
			Input(message[1], '...', 'WHITE', 'BLACKBG')
		end
	end
end

function ui.DisplaySetup(cols, rows, foreColor, backColor)
	local valid = false
	while not valid do	
		if isConsole then
			ui.Clear()
			print("This program uses coloured text and formatted menus")
			print("This can only be seen when run in terminal or IDEs with ansi console:")
			print("(Example Visual Studio Code)")			
			print()
			print("The terminal has been set to "..cols.." x "..rows.." with "..foreColor.." text on "..backColor.." background.")
			if osName == 'nt' then -- Windows cmd
				print()
				print("If the font size is too small:")
				print()
				print("\t1) Right-click on the title bar and select 'Properties'")
				print("\t2) Select the 'Font' tab")
				print("\t3) Change the size to suit")
				print("\t4) Click 'Close' (The window will resize)")
				print()
			else
				print()
				print("If the font size is too small:")
				print()
				print("\t1) Menu -> Edit -> Preferences")
				print("\t2) Select the 'Text' tab")
				print("\t3) Change the 'Size' to suit")
				print("\t4) Click 'OK' (The window will resize)")
				print("\t5) Repeat steps 1 and 4 if you change window position")
			end
			print() --14
			ui.ColorPrint("Do ~red~NOT~white~ resize this window as it will mess up the menus!") --line 15
			ui.AddLines(5) --line 19
		else
			print(" 1 This program uses coloured text and formatted menus\n 2")
			print(" 3 This can only be seen when run in terminal or IDEs with ANSI console:")
			print(" 4 (Visual Studio Code or Wing Personal with I/O set to external console)")			
			print(" 5\n 6 Important!")
			print(" 6\n 7 A line of characters has been drawn on line 24 below")
			print(" 8 Resize the output window so you can see lines 1 to 25 only")
			print(" 9 Follow the instruction on line 25")
			for i = 10, 24 do
				print(i)
			end
			io.write("24 ")
			ui.DrawLine('d', 'white', 'BLACKBG') --line 24
			Input("25 Enter to continue")
		end
		if isConsole then
			ui.DrawLine('d', 'RED','BLACKBG')
			-- prompt, promptChar, textColor, backColor
			valid, userInput, message = GetBoolean("Is the line above red on a black background? (y/n)", '>_', 'white', 'blackbg')
			if valid then
				isColoured = userInput -- User entered true/false
			else
				ui.ColorPrint(RED..message..MAGENTA..' retry in 2 secs...')
				Sleep(2)
			end
		else
			valid = true
		end
	end	
	ui.Clear()
	if isConsole then
		if not isColoured then
			print("You are running from a non-compliant IDE\n")
			print("Coloured text will NOT be displayed\n")
			print("The game will still run!\n")
			if osName == 'nt' then -- Windows cmd
				print("Try double-clicking 'program.lua' in Windows Explorer")
				print("Or running 'python program.lua' in cmd or powershell")
			else
				print("Try typing 'lua program.lua' in terminal\n")
			end
			print("(make sure you are in the correct directory!)")
			ui.AddLines(14)
			ui.DrawLine('d', WHITE) --line 21
			Input("Press Enter to continue")
		end
		ui.Clear()
	end
end

function ui.DrawBoxBody(style, text, boxAlign, foreColor, backColor, textColor, textBackColor, textAlign, width)
	--[[ print out single line body section of a box with text / spaces "║  text  ║"  ]]
	textColor = textColor or 'WHITE'
	textBackColor = textBackColor or 'BLACKBG'
	textAlign = textAlign or 'left'
	width = width or 0
	style = FixStyle(style)
	foreColor, backColor = ValidateColors(foreColor, backColor)
	textColor, textBackColor = ValidateColors(textColor, textBackColor)
	boxAlign = ValidateAlignment(boxAlign)                            -- check alignments are in permitted list
	textAlign = ValidateAlignment(textAlign)
	local s = SelectCharacterList("body", style)        -- { "║", " ", "║", "║" };
	if width > windowWidth or width <= 0 then width = windowWidth end
	local output = PadString(text, width - 2, " ", textAlign)  -- "  text  " -2 to allow for start/end margin chars
	local sides = { s[1], s[3] }
	sides = PadBoxSides(sides, output, boxAlign)
	-- foreColor border on backColor -> colour formatted text -> foreColor border on backColor
	ui.ColorPrint(foreColor..backColor..sides[1]..textColor..textBackColor..output..foreColor..backColor..sides[2])

	return 1 -- single line used
end

function ui.DrawBoxOutline(style, part, foreColor, backColor, boxAlign, width, midMargin)
	--[[ Draw the top, mid or bottom of a box to width ]]
	boxAlign = boxAlign or 'left'
	width = width or 0
	midMargin = midMargin or false
	style = FixStyle(style)
	foreColor, backColor = ValidateColors(foreColor, backColor)
	boxAlign = ValidateAlignment(boxAlign)
	part = ValidateBoxPart(part)
	sides = { "", "" }
	local s = SelectCharacterList(part, style)
	if width > windowWidth or width <= 0 then width = windowWidth end
	sides[1] = s[1]                                            -- start with left corner
	sides[2] = s[3]                                            -- end with right corner
	if midMargin then
		sides[1] = SelectCharacterList("mid", style)[1]        -- "├"
		sides[2] = SelectCharacterList("mid", style)[3]        -- "┤"
	end
	local output = PadString("", width - 2, s[2], boxAlign)   -- -2 to allow for start/end margin chars
	sides = PadBoxSides(sides, output, boxAlign)
	-- line padded, now do same for spaces around the line
	output = foreColor..backColor..sides[1]..output..foreColor..backColor..sides[2]
	ui.ColorPrint(output)

	return 1 -- single line used
end

function ui.DrawGridBody(style, part, columns, boxColor, boxBackColor, textColor, textBackColor, textLines, alignments)
	--[[ Draw the body of a grid to width ]]
	style = FixStyle(style)
	boxColor, boxBackColor = ValidateColors(boxColor, boxBackColor)
	textColor, textBackColor = ValidateColors(textColor, textBackColor)
	local s = SelectCharacterList(part, style)              -- '│', ' ', '│', '│'
	local outputs = {}
	local output = ''
	for col = 1, #columns do
		output = ''
		local colWidth = columns[col]                       -- eg {10, 20, 20, 30 } = 80 cols
		local lSide
		local rSide
		if col == 1 then -- first column 
			lSide = s[1]                                    -- '│'
			rSide = s[4]                                    -- '│'
		elseif col == #columns then
			lSide = s[2]                                    -- '│'
			rSide = s[3]                                    -- '│'
		else
			lSide = s[2]                                    -- ' '
			rSide = s[4]                                    -- '│'
		end
		local text = ""
		if col <= #textLines then
			text = textLines[col]
		end
		output = PadString(text, colWidth - 2, " ", alignments[col])          -- -2 to allow for start/end margin chars
		output = boxColor..boxBackColor..lSide..textColor..textBackColor..output..boxColor..boxBackColor..rSide
		table.insert(outputs, output)                                        -- create new list item with completed string
	end
	output = ''
	for i = 1,  #outputs do -- concatenate all box outlines in outputs
		output = output..outputs[i]
	end
	ui.ColorPrint(output)

	return 1 -- single line used
end

function ui.DrawGridOutline(style, part, columns, foreColor, backColor, midMargin)
	--[[ Draw the top, mid or bottom of a grid to width ]]
	if midMargin == nil then midMargin = false end
	style = FixStyle(style)
	foreColor, backColor = ValidateColors(foreColor, backColor)
	local s = SelectCharacterList(part, style)              		-- "┌", "─", "┐", "┬"
	local outputs = {}
	local output
	for col = 1, #columns do
		local colWidth = columns[col]                               -- eg {10, 20, 20, 30 } = 80 cols
		local lSide                                        			-- "┌"
		local rSide                                        			-- "┐"
		if col == 1 then
			lSide = s[1]                                           	-- "┌"
			if midMargin then
				lSide = SelectCharacterList("mid", style)[1] 		-- "├"
			end
			rSide = s[4]                                           	-- "┬"
		elseif col == #columns then
			lSide = s[2]                                           	-- "─"
			rSide = s[3]                                           	-- "┐"
			if midMargin then
				rSide = SelectCharacterList("mid", style)[3] 		-- '├', '─', '┤', '┼'
			end
		else
			lSide = s[2]                                           -- "─"
			rSide = s[4]                                           -- "┬"
		end
		output = PadString("", colWidth - 2, s[2], "left");         -- -2 to allow for start/end margin chars
		output = foreColor..backColor..lSide..output..rSide
		table.insert(outputs, output)                                       -- create new list item with completed string
	end
	output = ''
	for i = 1, #outputs do -- concatenate all box outlines in outputs
		output = output..outputs[i]
	end
	ui.ColorPrint(output)

	return 1 -- single line used
end

function ui.DrawLine(style, lineColor, backColor, width, align)
	align = align or 'left'
	style = FixStyle(style)
	lineColor, backColor = ValidateColors(lineColor, backColor)
	align = ValidateAlignment(align)
	width = width or windowWidth
	local s = SelectCharacterList('mid', style)
	local line = ''
	if width == windowWidth then
		line = PadString('', width, s[2], 'left')
	else
		line = PadString('', width, s[2], 'left')
		line = PadString(line, windowWidth, ' ', align)
	end
	ui.ColorPrint(lineColor..backColor..line)
	return 1
end

function ui.DrawMultiBoxBody(styles, sizes, foreColors, backColors, textLines, alignments, padding )
	--[[ print out single line mid section of multiple boxes with or without text ]]
	padding = padding or 0
	assert(#styles == #sizes and #styles == #foreColors and #styles == #backColors and #styles == #alignments,
			"All supplied parameter lists must have the same number of items")
	for i = 1, #styles do
		styles[i] = FixStyle(styles[i])
	end
	for i = 1, #foreColors do
		local foreColor = foreColors[i]
		local backColor = backColors[i]
		foreColor, backColor = ValidateColors(foreColor, backColor)
		foreColors[i] = foreColor
		backColors[i] = backColor
	end
	for i = 1, #alignments do
		local align = alignments[i]
		align = ValidateAlignment(align)
		alignments[i] = align
	end
	local outputs = {}
	-- calculate each box size from sizes: {15, 40, 25} 
	local boxLength
	local output
	for i = 1, #sizes do
		-- size examples {15, 40, 25} = 80 cols
		local s = SelectCharacterList("body", styles[i])
		if i < #sizes then
			boxLength = sizes[i] - padding - 2     -- -2 as is box edge, and characters will be added both sides
		else 
			boxLength = sizes[i] - 2
		end
		local lSide = s[1]                                                -- start with left side char
		local rSide = s[4]                                                -- end with right side char
		--check length of string
		output = textLines[i]
		local colorTagSpaces, output, embeddedColors = FormatColorTags(output)
		if #output > sizes[i] - 2 + colorTagSpaces then
			output = output:sub(1, sizes[i] - 2 + colorTagSpaces)
		end
		output = PadString(output, boxLength, " ", alignments[i])
		output = foreColors[i]..backColors[i]..lSide..output..foreColors[i]..backColors[i]..rSide
		table.insert(outputs, output)                                 -- create new list item with completed string
	end

	output = ""
	for i = 1, #outputs do                       -- concatenate all box outlines in outputs
		output = output..outputs[i]
	end
	ui.ColorPrint(output)

	return 1 -- single line used
end

function ui.DrawMultiBoxOutline(styles, part, sizes, foreColors, backColors, padding)
	--[[ Draw the top/bottoms of sizes.Count boxes, width in absolute values ]]
	padding = padding or 0
	assert(#styles == #sizes and #styles == #foreColors and #styles == #backColors, "All supplied parameter lists must have the same number of items")
	for i = 1, #styles do
		styles[i] = FixStyle(styles[i])
	end
	for i = 1, #foreColors do
		local foreColor = foreColors[i]
		local backColor = backColors[i]
		foreColor, backColor = ValidateColors(foreColor, backColor)
		foreColors[i] = foreColor
		backColors[i] = backColor
	end
	local outputs = {}
	-- calculate each box size from sizes: {15, 40, 25} 
	local boxLength
	local output
	for i = 1, #sizes do
		-- size examples {15, 40, 25} = 80 cols
		s = SelectCharacterList(part, styles[i])
		if i < #sizes then
			boxLength = sizes[i] - padding - 2     -- -2 as is box edge, and characters will be added both sides
		else
			boxLength = sizes[i] - 2
		end
		local lSide = s[1]                                                -- start with left corner
		local rSide = s[3]                                                -- end with right corner
		
		output = PadString("", boxLength, s[2], "left")
		output = foreColors[i]..backColors[i]..lSide..output..foreColors[i]..backColors[i]..rSide
		table.insert(outputs, output)        -- create new list item with completed string
	end

	output = ''
	for i = 1, #outputs do                       -- concatenate all box outlines in outputs
		output = output..outputs[i]
	end
	ui.ColorPrint(output)

	return 1 --single line
end

function ui.DrawMultiLineBox(style, textLines, foreColor, backColor, textColor, textBackColor, boxAlign, textAlign, width)
	--[[  Draw a single box containing many lines of text overloaded function textLines can be string or table ]]
	textColor = textColor or 'white'
	textBackColor = textBackColor or 'blackbg'
	boxAlign = boxAlign or "left"
	textAlign = textAlign or "left"
	width = width or 0
	local numLines = 0
	style = FixStyle(style)
	foreColor, backColor = ValidateColors(foreColor, backColor)
	textColor, textBackColor = ValidateColors(textColor, textBackColor)
	if type(textLines) ~= "table" then
		textLines = textLines:Split('\n', nil, nil, false)
	end
	if width > windowWidth or width <= 0 then width = windowWidth end
	numLines = numLines + ui.DrawBoxOutline(style, "top", foreColor, backColor, boxAlign, width)
	textLines = GetFormattedLines(textLines, width)
	for i = 1, #textLines do
		numLines = numLines + ui.DrawBoxBody(style, textLines[i], boxAlign, foreColor, backColor, textColor, textBackColor, textAlign, width)
	end
	numLines = numLines + ui.DrawBoxOutline(style, "bottom", foreColor, backColor, boxAlign, width)

	return numLines
end

function ui.Print(text, foreColor, backColor)
	foreColor = foreColor or 'WHITE'
	backColor = backColor or 'BLACKBG'
	foreColor, backColor = ValidateColors(foreColor, backColor)
	ui.ColorPrint(foreColor..backColor..text)
end

function ui.InputBox(style, returnType, title, boxMessage, inputPrompt, promptChar, foreColor, backColor, width, minReturnLen, maxReturnLen, withTitle)
	--[[Draw an inputBox with title, message, input area
		Example "bool", "File Exists Warning", "Are you sure you want to over-write?", "Confirm over-write (y/n)_" ]]
	foreColor = foreColor or 'white'
	backColor = backColor or 'blackbg'
	width = width or 0
	minReturnLen = minReturnLen or 1
	maxReturnLen = maxReturnLen or 20
	withTitle = withTitle or false
	style = FixStyle(style)
	foreColor, backColor = ValidateColors(foreColor, backColor)
	if width > windowWidth or width <= 0 then width = windowWidth end
	local isValid = false
	local userInput = ''
	local message = ''
	while not isValid do
		ui.Clear()
		local textLines = GetFormattedLines(boxMessage); -- returns a list of lines max length of any line Console.Windowwidth - 3
		local numLines = ui.DrawBoxOutline(style, "top", foreColor, backColor, "centre", width); -- draw top of box double line, yellow
		numLines = numLines + ui.DrawBoxBody(style, title, "centre", foreColor, backColor, foreColor, backColor, "centre", width) -- draw title
		numLines = numLines + ui.DrawBoxOutline(style, "mid", foreColor, backColor, "centre", width); -- draw single line
		for i = 1,  #textLines do
			numLines = numLines + ui.DrawBoxBody(style,  textLines[i], "centre", foreColor, backColor, foreColor, backColor, "left", width) -- draw each line of text
		end
		numLines = numLines + ui.DrawBoxBody(style, "", "centre", foreColor, backColor, foreColor, backColor, "centre", width) -- draw empty line
		numLines = numLines + ui.DrawBoxOutline(style, "bottom", foreColor, backColor, "centre", width) -- draw bottom of box double line, yellow
		ui.AddLines(5, numLines)
		ui.DrawLine("d", 'WHITE', 'BLACKBG')
		if returnType == "str" or returnType == "string" then
			isValid, userInput, message = GetString(inputPrompt, promptChar, foreColor, backColor, withTitle, minReturnLen, maxReturnLen)
		elseif returnType == "int" then
			isValid, userInput, message = GetInteger(inputPrompt, promptChar, foreColor, backColor, minReturnLen, maxReturnLen)
		elseif returnType == "real" or returnType == "float" or returnType == "double" then
			isValid, userInput, message = GetRealNumber(inputPrompt, promptChar, foreColor, backColor, minReturnLen, maxReturnLen)
		elseif returnType == "bool" or returnType == "boolean" then
			isValid, userInput, message = GetBoolean(inputPrompt, promptChar, "", "");
		end
		if not isValid then
			ui.ColorPrint(RED..message..MAGENTA.." retry in 2 secs...")
			Sleep(2)
		end
	end
	return userInput -- string eg filename typed in, || bool
end

function ui.PrintMessage(message, delay, messageColor, delayColor)
	backColor = 'BLACKBG' -- dummy variable
	messageColor = messageColor or RED
	delayColor = delayColor or MAGENTA
	delayColor, backColor = ValidateColors(delayColor, backColor)
	messageColor, backColor = ValidateColors(messageColor, backColor)
	ui.ColorPrint(messageColor..message)
	ui.ColorPrint(delayColor..'Retry in '..delay..' secs...')
	Sleep(delay)
end

function ui.Quit(withConfirm)
	if withConfirm == nil then withConfirm = true end
	if withConfirm then
		io.write("Enter to quit")
		io.read()
	end
	ui.Clear()
end

--[[ demo functions  ]]
function ui.ColorPrintDemo()
	--[[use {{ and }} to escape {} interpolated strings. Use (char)34 to insert " into strings alternative to escaping with \"]]
	ui.Clear()
	ui.ColorPrint(WHITE.."WHITE..This line is white on black.")
	ui.ColorPrint(GREY.."GREY..This line is grey on black.")
	ui.ColorPrint(DGREY.."DGREY..This line is dark grey on black.")
	ui.ColorPrint(BLUE.."BLUE..This line is blue on black.")
	ui.ColorPrint(GREEN.."GREEN..This line is green on black.")
	ui.ColorPrint(CYAN.."CYAN..This line is cyan on black.")
	ui.ColorPrint(RED.."RED..This line is red on black.")
	ui.ColorPrint(MAGENTA.."MAGENTA..This line is magenta on black.")
	ui.ColorPrint(YELLOW.."YELLOW..This line is yellow on black.")
	ui.ColorPrint(DBLUE.."DBLUE..This line is dark blue on black.")
	ui.ColorPrint(DGREEN.."DGREEN..This line is dark green on black")
	ui.ColorPrint(DCYAN.."DCYAN..This line is dark cyan on black.")
	ui.ColorPrint(DRED.."DRED..This line is dark red on black.")
	ui.ColorPrint(DMAGENTA.."DMAGENTA..This line is dark magenta on black.")
	ui.ColorPrint(DYELLOW.."DYELLOW..This line is dark yellow on black.")
	ui.ColorPrint(BLACK..WHITEBG.."BLACK..WHITEBG..This line is black on white.")
	ui.ColorPrint(WHITE.."WHITE..This line is white, and now "..RED.."..RED..red on black.")
	ui.ColorPrint(GREEN..REDBG.."GREEN..REDBG..This line is green "..RED..GREENBG.."RED..GREENBG.. on red.")
	ui.ColorPrint(RED..GREENBG.."RED..GREENBG..This line is red"..GREEN..REDBG.."..GREEN..REDBG.. on green.")
	ui.AddLines(5, 19)
	ui.DrawLine("d", "WHITE", "BLACKBG")
	ui.DisplayMessage("Press Enter to continue...", true, false)
end

function ui.GetInputDemo(demoType, description)
--[[ Most UI operations should be done within this UI class
	Try to keep all I/O operations out of other classes
	This will make transfer of code to a GUI much easier    ]]
	local valid = false
	local userInput = ''
	local message = ''
	while not valid do
		ui.Clear()
		local numLines = ui.DrawMultiLineBox("s", description, "yellow", "black", "white", "black", "left")
		ui.AddLines(5, numLines) -- pad Console to leave 5 empty lines
		ui.DrawLine("d", "white", "black") -- now leaves 4 empty lines
		if demoType == "string" then
			-- GetString(prompt, promptChar, textColor, backColor, withTitle, min, max)
			valid, userInput, message = GetString("UI.GetString: Type your name (1-10 chars)", ">_", "green", "black", true, 1, 10)
		elseif demoType == "int"  then
			valid, userInput, message = GetInteger("UI.GetInteger: Type your age (5-100)", ">_", "cyan", "black", 5, 100)
		elseif demoType == "real" then
			valid, userInput, message = GetRealNumber("UI.GetRealNumber: Type your height in metres (0.5 to 2.0)", ">_", "magenta", "black", 0.5, 2)
		elseif demoType == "bool" then
			valid, userInput, message = GetBoolean("UI.GetBoolean: Is this library useful (y/n)?", ">_", "blue", "black")
		end
		if message ~= '' then
			ui.DisplayMessage(message, false, true, "red", "black")
		end
	end

	return userInput
end

function ui.GamePlayGame(secretNumber)
	local guess = 0
	local attempts = 0
	while guess ~= secretNumber do
		attempts = attempts + 1
		ui.Clear()
		--InputBox(style, returnType, title, boxMessage, inputPrompt, promptChar, foreColor, backColor, width, minReturnLen, maxReturnLen, withTitle)
		local userInput = ui.InputBox("s", "int", "~magenta~Guess The Number", "~cyan~See if you can guess the number",
			"Type your guess for the secret number,(1 to 100)", ">_", "green", "black", 60, 1, 100);
		guess = tonumber(userInput)
		if guess > secretNumber then
			ui.DisplayMessage("Sorry, your guess "..guess.." was too high", false, true, "magenta", "black", 3)
		elseif guess < secretNumber then
			ui.DisplayMessage("Sorry, your guess "..guess.." was too low", false, true, "cyan", "black", 3)
		end
	end
	return attempts
end

function ui.GameShowEnding(description)
	ui.Clear()
	local numLines = ui.DrawMultiLineBox("s", description, "yellow", "black", "white", "black", "centre", "centre")
	numLines = numLines + ui.AddLines(2)
	ui.AddLines(5, numLines)
	ui.DrawLine("d", "white", "black")
	ui.DisplayMessage("", true, false)
end

function ui.GameShowIntro(description, intro)
	ui.Clear()
	local numLines = ui.DrawMultiLineBox("s", description, "yellow", "black", "white", "black", "centre", "center", 60)
	numLines = numLines + ui.AddLines(2)
	intro = intro:PadLeft(((windowWidth - #intro) / 2) + #intro)
	intro = intro:PadRight(windowWidth)
	numLines = numLines + Teletype(intro, .02, WHITE, REDBG)
	ui.AddLines(5, numLines)
	ui.DrawLine("d", "white", "black")
	ui.DisplayMessage("", true, false)
end

Initialise()

return ui