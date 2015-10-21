-- Include subdirs in search path
package.path = "./lua/?.lua;./listeners/?.lua;" .. package.path

--------------------
-- Load listeners --
--------------------

-- See http://sharkfest.wireshark.org/sharkfest.09/DT06_Bjorlykke_Lua%20Scripting%20in%20Wireshark.pdf

require("utils")
local packetinfo = require("packetinfo")

dofile("listeners/eth.lua")
-- dofile("listeners/arp.lua")
-- dofile("listeners/ip.lua") -- Useless
dofile("listeners/dropbox.lua")
-- dofile("listeners/nbns.lua") -- TODO all field missing
dofile("listeners/dhcp.lua") -- TODO it does not recognize unknown parameters
dofile("listeners/dhcpv6.lua")
dofile("listeners/mndp.lua") -- TODO missing fields, it does not recognize unknown parameters
dofile("listeners/stp.lua")
dofile("listeners/eap.lua")
dofile("listeners/cups.lua")
dofile("listeners/browser.lua") -- TODO some field missing
dofile("listeners/cdp.lua")
dofile("listeners/torrent-lpd.lua")
dofile("listeners/spotify.lua")
dofile("listeners/mcafee.lua")
dofile("listeners/hip.lua")
dofile("listeners/bjnp.lua")
dofile("listeners/fdp.lua")
dofile("listeners/lldp.lua")
dofile("listeners/ssdp.lua")
dofile("listeners/ws-discovery.lua")
