local colorsOut = require "ansicolors"
local colors 	= {}
local sep = "~"

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
	colors.BLACK 		= '%{black}'
	colors.WHITE 		= '%{white}'
	colors.GREEN 		= '%{green}'
	colors.RED 			= '%{red}'
	colors.BLACKBG 	 	= '%{blackbg}'
	colors.WHITEBG 	 	= '%{whitebg}'
end

local function ColorPrint(value, newline, reset)
	if newline == nil then newline = true end
	if reset == nil then reset = true end
	--[[
		This uses the default char ~ to separate colour strings                
		change the line:  sep = "~" as required                 				
		other possibles are ` (backtick) ¬ (?) any character you will not use  
		example value = "~red~This is a line of red text"
	]]              
	numLines = 0
	lineParts = value:Split(sep)
	for i = 1, #lineParts do
		part = lineParts[i]
		if colors[part:upper()]~= nil then-- is 'red' / 'RED' in the colorsOut dictionary?
			io.write(colorsOut.noReset(colors[part:upper()]))
		else -- not a colour command so print it out without newline
			if part:find("\n") ~= nil then
				numLines = numLines + 1
			end
			io.write(colorsOut.noReset(part))
		end
	end
	if reset then
		io.write(colorsOut('%{reset}'))
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
	Windows 10 users you MUST either Clear() or Resize() to enable ANSI codes in Lua scripts every time it is run ]]
	Initialise()
	Resize(80, 25)
	Clear()
	print(colorsOut("Hello %{red}Coloured %{green}World"))
	ColorPrint("Hello ~red~Coloured ~green~World")
	io.write("Enter to continue")
	io.read()
end

main()