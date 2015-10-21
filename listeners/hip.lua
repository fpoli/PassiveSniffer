-- Host Identity Protocol
local tap = Listener.new(nil, "hip")

-- Fields
local get_hip_hit_sndr = Field.new("hip.hit_sndr")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	local hit_sndr = tostring(get_hip_hit_sndr())

	packetinfo:single_attribute("hit.hit_sndr", hit_sndr)
end
