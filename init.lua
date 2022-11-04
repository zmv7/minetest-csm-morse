local morse_to_c = {
	[".-"]	= "a",
	["-..."]  = "b",
	["-.-."]  = "c",
	["-.."]   = "d",
	["."]	 = "e",
	["..-."]  = "f",
	["--."]   = "g",
	["...."]  = "h",
	[".."]	= "i",
	[".---"]  = "j",
	["-.-"]   = "k",
	[".-.."]  = "l",
	["--"]	= "m",
	["-."]	= "n",
	["---"]   = "o",
	[".--."]  = "p",
	["--.-"]  = "q",
	[".-."]   = "r",
	["..."]   = "s",
	["-"]	 = "t",
	["..-"]   = "u",
	["...-"]  = "v",
	[".--"]   = "w",
	["-..-"]  = "x",
	["-.--"]  = "y",
	["--.."]  = "z",
	["-----"] = "0",
	[".----"] = "1",
	["..---"] = "2",
	["...--"] = "3",
	["....-"] = "4",
	["....."] = "5",
	["-...."] = "6",
	["--..."] = "7",
	["---.."] = "8",
	["----."] = "9",
	}

local c_to_morse = table.key_value_swap(morse_to_c)


function morse_encode(str)
	if not str then return end
	local out = ""
	str:gsub(".", function(c)
		if c_to_morse[c] then
			out = out..c_to_morse[c].." "
		elseif c == " " then
			out = out.."/ "
		end
	end)
	return out
end

function morse_decode(str)
	if not str then return end
	local out = ""
	local morses = str:split(" ")
	for _,morse in ipairs(morses) do
		if morse_to_c[morse] then
			out = out..morse_to_c[morse]
		elseif morse == "/" then
			out = out.." "
		end
	end
	return out
end


core.register_on_receiving_chat_message(function(message)
	message = core.strip_colors(message)
	local text
	local sender, data = message:match("(%S+[:?>?])%s?(.+)")
	if data then
		text = morse_decode(data)
	end
	if not text then return end
	if text:match("%S+") and sender then
		core.after(0.1,function()
			core.display_chat_message(core.colorize('#FF0','Morse: '..sender).." "..text)
		end)
	end
end)
core.register_chatcommand("morse", {
  description = "Say in morse",
  func = function(param)
	if not param then return end
	param = param:lower()
	core.send_chat_message(morse_encode(param))
end})
