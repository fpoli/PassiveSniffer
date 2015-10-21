-- Link Layer Discovery Protocol
local tap = Listener.new(nil, "lldp")

-- Fields
-- local get_lldp = Field.new("lldp")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	packetinfo:single_attribute("lldp.detected", "True")
end
