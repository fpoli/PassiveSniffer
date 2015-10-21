local redis = require("redis")
local socket = require("socket")
local log = require("log")

local redisdb = redis.connect("localhost", 6379)

-- Global data structure
packetinfo = {}

packetinfo.get_mac = Field.new("eth.src")
packetinfo.get_ipv4 = Field.new("ip.src")
packetinfo.get_ipv6 = Field.new("ipv6.src")

function packetinfo:clear()
	self.mac = ""
	self.ip = ""
	self.timestamp = "0"
	self.protocol = ""
	self.discard = false
end
packetinfo:clear()

function packetinfo:init_packet(pinfo, tvb, tapinfo)
	assert(pinfo, "Wrong number of parameters " .. getstring(pinfo))

	self:clear()

	self.mac = getstring(self.get_mac()):gsub(":", ";")
	if self.get_ipv4() ~= nil then
		self.ip = getstring(self.get_ipv4())
	else
		if self.get_ipv6() ~= nil then
			self.ip = getstring(self.get_ipv6()):gsub(":", ";")
		end
	end
	self.timestamp = getstring(pinfo.abs_ts):gsub(",", ".")

	for i, finfo in ipairs({ all_field_infos() }) do
		if finfo.name:match("^[^.]*$") then
			self.protocol = finfo.name
		end
	end

	local private = is_private_ip(self.ip:gsub(";", ":"))
	self.discard = not (private or private == nil)

	if not self.discard then
		redisdb:set( string.format("mac:%s:timestamp", self.mac), self.timestamp )
		redisdb:sadd( string.format("mac:%s:ips", self.mac), self.ip )
		redisdb:set( string.format("mac:%s:ip:%s:timestamp", self.mac, self.ip), self.timestamp )
		redisdb:zadd( "events:mac", self.timestamp, self.mac )
	end

	-- self:log()
end

function packetinfo:single_attribute(attr, value)
	assert(attr, "Wrong number of parameters " .. getstring(attr))
	if not value or getstring(value) == "" then return end
	if self.discard then return end

	if not self.discard then
		redisdb:sadd( string.format("mac:%s:ip:%s:attributes", self.mac, self.ip), string.format("single:%s", attr) )
		redisdb:set( string.format("mac:%s:ip:%s:single:%s:value", self.mac, self.ip, attr), value )
		redisdb:set( string.format("mac:%s:ip:%s:single:%s:timestamp", self.mac, self.ip, attr), self.timestamp )
	end

	self:log(attr, value)
end

function packetinfo:multi_attribute(attr, value)
	assert(attr, "Wrong number of parameters " .. getstring(attr))
	if not value or getstring(value) == "" then return end

	if not self.discard then
		redisdb:sadd( string.format("mac:%s:ip:%s:attributes", self.mac, self.ip), string.format("multi:%s", attr) )
		redisdb:hset( string.format("mac:%s:ip:%s:multi:%s", self.mac, self.ip, attr), value, self.timestamp )
	end

	self:log(attr, value)
end

function packetinfo:log(attr, value)
	local msg = ("[-%.3f s]  %s  %-25s  [%-6s]"):format(
			socket.gettime() - self.timestamp:gsub("%.",","),
			self.mac:gsub("%;", ":"),
			self.ip:gsub("%;", ":"),
			self.protocol
		)
	local extra = ""
	if self.discard then
		extra = extra .. ("  (discard)")
	end
	if attr and value then
		extra = extra .. ("  %s: %s"):format(attr, value)
	end
	extra = truncate_with_ellipsis(extra, 80)
	log.info(msg .. extra)
end

return packetinfo
