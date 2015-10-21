-- Cisco Discovery Protocol
local tap = Listener.new(nil, "cdp")

-- Fields
local get_cdp_deviceid = Field.new("cdp.deviceid")
local get_cdp_portid = Field.new("cdp.portid")
local get_cdp_platform = Field.new("cdp.platform")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	packetinfo:single_attribute("cdp.deviceid", get_cdp_deviceid())
	packetinfo:single_attribute("cdp.portid", get_cdp_portid())
	packetinfo:single_attribute("cdp.platform", get_cdp_platform())
end
