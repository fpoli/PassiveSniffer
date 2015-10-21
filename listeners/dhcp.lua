-- Dynamic Host Configuration Protocol
local tap = Listener.new(nil, "bootp.dhcp")

-- Fields
local get_dhcp_type = Field.new("bootp.type")
local get_dhcp_option_hostname = Field.new("bootp.option.hostname")
local get_dhcp_option_requested_ip = Field.new("bootp.option.requested_ip_address")
local get_dhcp_option_vendor = Field.new("bootp.option.vendor.value")
local get_dhcp_option_vendor_class_id = Field.new("bootp.option.vendor_class_id")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	local dhcp_type = get_dhcp_type().value
	if (dhcp_type == 1) then
		packetinfo:single_attribute("dhcp.type", "Client")
	end
	if (dhcp_type == 2) then
		packetinfo:single_attribute("dhcp.type", "Server")
	end

	packetinfo:multi_attribute("dhcp.hostname", get_dhcp_option_hostname())
	packetinfo:multi_attribute("dhcp.vendor", get_dhcp_option_vendor())
	packetinfo:multi_attribute("dhcp.vendor_class_id", get_dhcp_option_vendor_class_id())
	packetinfo:single_attribute("dhcp.requested_ip", get_dhcp_option_requested_ip())

	-- TODO Detect if there are unexpected, interesting attributes
end
