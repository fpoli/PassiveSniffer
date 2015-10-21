local tap = Listener.new(nil, "stp")

-- Fields
local get_stp_root_hw = Field.new("stp.root.hw")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	packetinfo:multi_attribute("stp.root.hw", get_stp_root_hw())
end
