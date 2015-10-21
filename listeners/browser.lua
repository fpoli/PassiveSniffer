-- Microsoft Windows Browser Protocol
local tap = Listener.new(nil, "browser")

-- Fields
local get_browser_server = Field.new("browser.server")
local get_browser_comment = Field.new("browser.comment")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	packetinfo:multi_attribute("browser.server", get_browser_server())
	packetinfo:single_attribute("browser.comment", get_browser_comment())
end
