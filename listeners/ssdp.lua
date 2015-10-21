-- Simple Service Discovery Protocol
local tap = Listener.new(nil, "udp.dstport == 1900 && http")

-- Fields
-- local get_ssdp = Field.new("ssdp")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	packetinfo:single_attribute("ssdp.detected", "True")
end
