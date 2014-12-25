lang = {}

local language

if LANGUAGE_TYPE == 3 then
	language = require("scripts.localstring.lang_tw")
else
	language = require("scripts.localstring.lang_cn")
end

function lang.get(  name, ...  )
	local args = {...}
	local result = ""
	if language then
		if language[name] then
			result =  language[name]
		end
	end
	if result then
		for i=1,#args do
			result = string.gsub(result,"{" .. i .."}",args[i])
		end
	else
		print("name",name)
		result = ""
	end
	return result
end

return lang