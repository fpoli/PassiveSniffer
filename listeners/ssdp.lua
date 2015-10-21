-- Simple Service Discovery Protocol
local tap = Listener.new(nil, "udp.dstport == 1900 && http")

-- Fields
local get_http = Field.new("http")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	local data = get_readable(get_http().range:string())
	packetinfo:single_attribute("ssdp.data", data)
end
