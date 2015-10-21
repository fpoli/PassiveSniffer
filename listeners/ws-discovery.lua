-- Web Services Dynamic Discovery
local tap = Listener.new(nil, "udp.dstport == 3702 && ip.dst == 239.255.255.250")

-- Fields
local get_data = Field.new("data")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	local data = get_data().range:string()
	packetinfo:single_attribute("ws-discovery.data", data)
end
