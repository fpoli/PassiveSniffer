local tap = Listener.new(nil, "ip")

-- Fields
local get_ip_src = Field.new("ip.src")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

end
