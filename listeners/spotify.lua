local tap = Listener.new(nil, "udp.dstport == 57621")

-- Fields

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	packetinfo:single_attribute("spotify.detected", "True")
end
