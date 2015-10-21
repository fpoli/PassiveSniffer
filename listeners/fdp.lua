-- Foundry Discovery Protocol
local tap = Listener.new(nil, "fdp")

-- Fields
local get_fdp = Field.new("fdp")
local get_fdp_deviceid = Field.new("fdp.deviceid")
local get_fdp_net_ip = Field.new("fdp.net.ip")
-- local get_fdp_interface = Field.new("fdp.")
-- local get_fdp_capabilities = Field.new("fdp.")
-- local get_fdp_platform = Field.new("fdp.")
-- local get_fdp_version = Field.new("fdp.")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	local data = get_readable(get_fdp().range:string())

	packetinfo:single_attribute("fdp.data", data)
	packetinfo:single_attribute("fdp.version", get_fdp_version())
	packetinfo:single_attribute("fdp.get_fdp_deviceid", get_fdp_deviceid())
	packetinfo:single_attribute("fdp.net.ip", get_fdp_net_ip())
end
