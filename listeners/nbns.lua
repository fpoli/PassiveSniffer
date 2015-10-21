local tap = Listener.new(nil, "nbns")

-- Fields
local get_nbns_opcode = Field.new("nbns.flags.opcode")
local get_nbns_response = Field.new("nbns.flags.response")
-- TODO Make a patch to access detailed infos
--local get_nbns_src_name = Field.new("nbns.hostname")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)
	
	if get_nbns_opcode() == 0 and get_nbns_response() == 1 then -- Name Query Response
		-- FIXME Is this a positive or a negative response?
		--packetinfo:set_multi_attribute("netbios.name", get_nbns_src_name().value)
	elseif get_nbns_opcode() == 5 and get_nbns_response() == 0 then -- Registration Query
		--packetinfo:set_multi_attribute("netbios.name", get_nbns_src_name().value)
	end
end

