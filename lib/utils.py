#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import time
import re
from datetime import datetime
import socket, struct

def obj2timestamp(dtime):
	if not dtime:
		return dtime
	return time.mktime(dtime.timetuple()) + dtime.microsecond/1000000.0

def timestamp2obj(time):
	return datetime.fromtimestamp(time)

def sanitize_mac(mac):
	"""
	Remove bad characters from mac string
	"""
	mac = str(mac)
	mac = mac.lower()
	mac = re.sub(r'-', r':', mac)
	mac = re.sub(r'[^0-9a-f:]', r'', mac)
	return mac

def sanitize_string(string):
	"""
	Convert in unicode, then strip all white characters from the string
	"""
	try:
		return unicode(string).strip('\t\n\x0b\x0c\r \0')
	except:
		return None

def ip2long(ip):
	"""
	Convert an IP string to long
	"""
	packedIP = socket.inet_aton(ip)
	return struct.unpack("!L", packedIP)[0]

def get_layers(pkt):
	"""
	Get all layers of a packet sniffed via Scapy
	"""
	layers = []
	counter = 0
	while True:
		layer = pkt.getlayer(counter)
		if layer != None:
			layers.append(layer.name)
		else:
			break
		counter += 1
	return layers			
