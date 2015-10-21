-- Common Unix Printing System
local tap = Listener.new(nil, "cups")

-- Fields
local get_cups = Field.new("cups")
local get_cups_state = Field.new("cups.state")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_package(pinfo,tvb,tapinfo)

	local data = get_readable(get_cups().range:string())

	packetinfo:single_attribute("cups.state", get_cups_state())
	packetinfo:single_attribute("cups.data", data)
end
