local tap = Listener.new(nil, "arp")

-- Fields
local get_arp_src_mac = Field.new("arp.src.hw_mac")
local get_arp_src_ip = Field.new("arp.src.proto_ipv4")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	packetinfo:single_attribute("arp.src.mac", get_arp_src_mac().value)
	packetinfo:single_attribute("arp.src.ip", get_arp_src_ip())
end
