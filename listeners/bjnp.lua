-- Host Identity Protocol
local tap = Listener.new(nil, "bjnp")

-- Fields
local get_bjnp_type = Field.new("bjnp.type")
local get_bjnp_code = Field.new("bjnp.code")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	packetinfo:single_attribute("bjnp.type", get_bjnp_type().value)
	packetinfo:single_attribute("bjnp.code", get_bjnp_code().value)
end
