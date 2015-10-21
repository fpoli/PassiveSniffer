local tap = Listener.new(nil, "eap")

-- Fields
local get_eapol_version = Field.new("eapol.version")
local get_eapol_type = Field.new("eapol.type")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	packetinfo:single_attribute("eapol.version", get_eapol_version().value)
	packetinfo:single_attribute("eapol.type", get_eapol_type().value)
end
