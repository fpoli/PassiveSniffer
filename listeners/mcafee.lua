-- McAfee Network Agent
local tap = Listener.new(nil, "udp.dstport == 6646")

-- Fields
local get_data = Field.new("data.data")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	local data = get_readable(get_data().range:string())

	packetinfo:single_attribute("mcafee.data", data)
end
