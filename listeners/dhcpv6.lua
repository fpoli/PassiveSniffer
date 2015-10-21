-- Dynamic Host Configuration Protocol version 6
local tap = Listener.new(nil, "dhcpv6")

-- Fields
local get_dhcpv6_domain = Field.new("dhcpv6.domain")
local get_dhcpv6_vendorclass_enterprise = Field.new("dhcpv6.vendorclass.enterprise")
local get_dhcpv6_vendorclass_data = Field.new("dhcpv6.vendorclass.data")

function tap.packet(pinfo,tvb,tapinfo)
	packetinfo:init_packet(pinfo,tvb,tapinfo)

	packetinfo:multi_attribute("dhcpv6.domain", get_dhcpv6_domain())
	packetinfo:multi_attribute("dhcpv6.vendorclass.enterprise", get_dhcpv6_vendorclass_enterprise().value)
	packetinfo:multi_attribute("dhcpv6.vendorclass.data", get_dhcpv6_vendorclass_data())

	-- TODO Detect if there are unexpected, interesting attributes
end
