#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import sys
import redis

from nicelogging import logger
from utils import *
from options import *


load_options()
if options.db_unix_socket:
	logger.info("(*) Connessione a Redis: db %d socket unix %s...", options.db_num, options.db_unix_socket)
	redisdb = redis.Redis(unix_socket_path=options.db_unix_socket, db=options.db_num)
else:
	logger.info("(*) Connessione a Redis: db %d host %s:%d...", options.db_num, options.db_host, options.db_port)
	redisdb = redis.Redis(host=options.db_host, port=options.db_port, db=options.db_num)

# Attributes
attribute_description = {}
"""attribute_description = {
	"mac": "Indirizzo MAC",
	"ip": "Indirizzo IP",
	# NetBIOS
	"netbios.name": "Netbios name",
	# DHCP
	"dhcp.hostname": "DHCP hostname",
	"dhcp.vendor": "DHCP vendor",
	# Dropbox
	"dropbox.host.int": "Dropbox host int",
	"dropbox.version": "Dropbox version",
	"dropbox.shared.folders": "Dropbox shared folders",
	# Mikrotik Neighbor Discovery Protocol
	"mndp.version": "MNDP version",
	"mndp.uptime": "MNDP uptime",
	"mndp.software.id": "MNDP software id",
	"mndp.unpack": "MNDP unpack",
	"mndp.platform": "MNDP platform",
	"mndp.identity": "MNDP identity",
	"mndp.board": "MNDP board",
	"mndp.interface": "MNDP interface",
}"""

# Operations
def get_mac_by_timestamp(min="-inf", max="+inf", pipe=redisdb):
	mac_list = redisdb.zrangebyscore("events:mac", min, max, withscores=True)
	return [ (mac.replace(";",":"), score) for (mac, score) in mac_list ]

def get_mac_ips(mac, pipe=redisdb):
	mac = mac.replace(":",";")
	ip_list = pipe.smembers("mac:{}:ips".format(mac))
	return [ip.replace(";",":") for ip in ip_list]

def get_mac_timestamp(mac, pipe=redisdb):
	mac = mac.replace(":",";")
	return float(pipe.get("mac:{}:timestamp".format(mac)))

def get_mac_ip_timestamp(mac, ip, pipe=redisdb):
	mac = mac.replace(":",";")
	ip = ip.replace(":",";")
	return float(pipe.get("mac:{}:ip:{}:timestamp".format(mac, ip)))

def get_mac_ip_attribute_names(mac, ip, pipe=redisdb):
	mac = mac.replace(":",";")
	ip = ip.replace(":",";")
	return pipe.smembers("mac:{}:ip:{}:attributes".format(mac, ip))


def get_attribute(mac, ip, attr, pipe=redisdb):
	mac = mac.replace(":",";")
	ip = ip.replace(":",";")
	return (
		pipe.get("mac:{}:ip:{}:single:{}:value".format(mac, ip, attr)),
		float(pipe.get("mac:{}:ip:{}:single:{}:timestamp".format(mac, ip, attr)))
	)

def get_multiattribute(mac, ip, attr, pipe=redisdb):
	mac = mac.replace(":",";")
	ip = ip.replace(":",";")
	items = pipe.hgetall("mac:{}:ip:{}:multi:{}".format(mac, ip, attr)).items()
	return { key: float(val) for key, val in items }

# Derived
def get_mac_last_ip(mac, pipe=redisdb):
	ip_list = get_mac_ips(mac)
	max_timestamp = 0
	last_ip = None
	for ip in ip_list:
		timestamp = get_mac_ip_timestamp(mac, ip)
		if timestamp > max_timestamp:
			max_timestamp = timestamp
			last_ip = ip
	return last_ip

def get_mac_attribute_values(mac, from_time):
	ip_list = get_mac_ips(mac)
	attributes = []
	for ip in ip_list:
		timestamp = get_mac_ip_timestamp(mac, ip)
		if timestamp >= from_time:
			attributes.append((
				ip,
				get_mac_ip_attribute_values(mac, ip, from_time),
				timestamp2obj(timestamp)
			))
	return attributes

def get_mac_ip_attribute_values(mac, ip, from_time):
	"""
	Returns the attributes associated with the given mac
	only if attribute's timestamp is greater than from_time
	"""
	# Array of (description, value, timestamp)
	attributes = []
	attribute_summary = get_mac_ip_attribute_names(mac, ip)
	for composite_name in attribute_summary:
		(mode, attr) = composite_name.split(":")
		
		if attr in attribute_description:
			attr_description = attribute_description[attr]
		else:
			logger.debug("Attributo %s sconosciuto" % attr)
			attr_description = attr
		
		if mode == "multi":
			value_dict = get_multiattribute(mac, ip, attr)
			attributes += [
				(attr_description, value, value_dict[value])
				for value in value_dict
				if value_dict[value] >= from_time
			]
		else:
			(value, timestamp) = get_attribute(mac, ip, attr)
			if timestamp >= from_time:
				attributes.append((attr_description, value, timestamp))
	return attributes
