local tap = Listener.new(nil, "mndp")

-- Fields
local get_mndp_mac = Field.new("mndp.mac")
local get_mndp_unpack = Field.new("mndp.unpack")
local get_mndp_uptime = Field.new("mndp.uptime")
local get_mndp_version = Field.new("mndp.version")
local get_mndp_softwareid = Field.new("mndp.softwareid")
local get_mndp_platform = Field.new("mndp.platform")
local get_mndp_identity = Field.new("mndp.identity")
local get_mndp_board = Field.new("mndp.board")
-- TODO interface
-- local get_mndp_interface = Field.new("mndp.interface")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)
	
	packetinfo:multi_attribute("mndp.unpack", get_mndp_unpack())
	packetinfo:single_attribute("mndp.uptime", get_mndp_uptime())
	packetinfo:multi_attribute("mndp.version", get_mndp_version())
	packetinfo:multi_attribute("mndp.software.id", get_mndp_softwareid())
	packetinfo:multi_attribute("mndp.platform", get_mndp_platform())
	packetinfo:multi_attribute("mndp.identity", get_mndp_identity())
	packetinfo:multi_attribute("mndp.board", get_mndp_board())

	-- TODO Recognize interface
	-- TODO Detect if there are unexpected, interesting attributes
end
