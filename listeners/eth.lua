local tap = Listener.new(nil, "eth")

-- Fields
local get_eth_src = Field.new("eth.src")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	local mac = getstring(get_eth_src().value)
	local pieces, num = split(mac, "_")

	if num == 2 then
		local vendor = pieces[1]
		packetinfo:single_attribute("mac.vendor", vendor)
	else
		if num ~= 1 then
			log.warning("Malformed mac: " .. mac)
		end
	end
end
