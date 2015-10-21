local color = require 'ansicolors'
local io = require 'io'
local log = {}

function log.error(message)
	io.write(tostring(color.red))
	print("/!\\ " .. message)
	io.write(tostring(color.clear))
end

function log.warning(message)
	io.write(tostring(color.yellow))
	print("/!\\ " .. message)
	io.write(tostring(color.clear))
end

function log.info(message)
	print(message)
end

function log.debug(message)
	io.write(tostring(color.black))
	print("(D) " .. message)
	io.write(tostring(color.clear))
end

return log
