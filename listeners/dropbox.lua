-- Dropbox Protocol
local tap = Listener.new(nil, "db-lsp-disc")

local json = require 'json'

-- Fields
local get_dropbox_text = Field.new("db-lsp.text")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	local text = json:decode(get_dropbox_text().value)
	
	packetinfo:multi_attribute("dropbox.host.int", text.host_int)
	packetinfo:multi_attribute("dropbox.version", table.concat(text.version, "."))
	packetinfo:multi_attribute("dropbox.displayname", text.displayname)
	packetinfo:multi_attribute("dropbox.port", text.port)

	if text.namespaces then
		-- avoid storing permutations
		table.sort(text.namespaces)
		packetinfo:multi_attribute("dropbox.shared.folders", "["..table.concat(text.namespaces, ", ").."]")
	end
end
