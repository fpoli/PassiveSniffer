-- Torrent Local Peer Discovery (peer-to-peer)
local tap = Listener.new(nil, "udp.dstport == 6771")

-- Fields
local get_lpd_data = Field.new("data.data")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	local lpd_data = get_lpd_data().range:string()
	local listenting_port = string.match(lpd_data, "Port: (%d+)")
	local infohash = string.match(lpd_data, "Infohash: ([0-9abcdefABCDEF]+)")

	packetinfo:single_attribute("torrent.lpd.listenting_port", listenting_port)
	packetinfo:multi_attribute("torrent.lpd.infohash", infohash)
end
