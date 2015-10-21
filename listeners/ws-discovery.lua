-- Web Services Dynamic Discovery
local tap = Listener.new(nil, "udp.dstport == 3702 && ip.dst == 239.255.255.250")

-- Fields
-- local get_ws_discovery = Field.new("ws-discovery")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	packetinfo:single_attribute("ws-discovery.detected", "True")
end
