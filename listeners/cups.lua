local tap = Listener.new(nil, "cups")

-- Fields
local get_cups_state = Field.new("cups.state")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_package(pinfo,tvb,tapinfo)

	packetinfo:single_attribute("cups.state", get_cups_state())

	-- TODO Get uri, location, information, make and model
end
