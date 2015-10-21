#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os.path
import time
import math
from datetime import datetime, timedelta

# Tornado imports
import tornado.ioloop
import tornado.httpserver
import tornado.web

# App imports
from lib.nicelogging import logger
from lib.utils import *			
from lib.options import *
from lib.models import *

class Application(tornado.web.Application):
	def __init__(self, auth_handlers=None):
		global redisdb
		
		handlers = [
			(r"/(\d*)", TableHandler),
			(r"/lastactivity/?(\d*)", LastactivityHandler),
			(r"/data/lastactivity/?(\d*)", DataLastactivityHandler),
			
			(r"/ipmap/?(\d*)", IpmapHandler),
			(r"/data/ipmap/?(\d*)", DataIpmapHandler),
			(r"/static/(.*)", tornado.web.StaticFileHandler),
		]
		settings = dict(
			host=options.host,
			debug=options.debug,
			template_path=os.path.join(os.path.dirname(__file__), "templates"),
			static_path=os.path.join(os.path.dirname(__file__), "static"),
			cookie_secret="nzjx1j4sh)zmulzdf023(adhj29s18w3ns5d7s?sdads/Vo=",
			xsrf_cookies=True,
		)
		tornado.web.Application.__init__(self, handlers, **settings)
		
		self.redisdb = redisdb


class BaseHandler(tornado.web.RequestHandler):
	@property
	def redisdb(self):
		return self.application.redisdb

class TableHandler(BaseHandler):
	def get(self, minutes):
		try:
			minutes = int(minutes)
		except:
			minutes = 30

		from_time = time.time() - 60*minutes
		event_list = get_mac_by_timestamp(min=from_time)
		event_list = event_list[::-1]

		data_list = [
			(
				mac,
				get_mac_attribute_values(mac, from_time),
				timestamp2obj(timestamp)
			)
			for (mac, timestamp) in event_list
		]

		self.render(
			"table.html",
			minutes = minutes,
			active_hosts = len(data_list),
			data = data_list,
			datetime = time.strftime("%Y-%m-%d %H:%M:%S")
		)

class LastactivityHandler(BaseHandler):
	def get(self, minutes):
		try:
			minutes = int(minutes)
		except:
			minutes = 30
		
		self.render(
			"lastactivity.html",
			minutes = minutes,
			datetime = time.strftime("%Y-%m-%d %H:%M:%S")
		)

class DataLastactivityHandler(BaseHandler):
	def get(self, minutes):
		try:
			minutes = int(minutes)
		except:
			minutes = 30
		
		from_time = time.time() - 60*minutes
		event_list = get_mac_by_timestamp(min=from_time)
		
		data = [row[1] for row in event_list]
		
		self.render(
			"data.json",
			data = data
		)


class IpmapHandler(BaseHandler):
	def get(self, minutes):
		try:
			minutes = int(minutes)
		except:
			minutes = 30
		
		self.render(
			"ipmap.html",
			minutes = minutes,
			datetime = time.strftime("%Y-%m-%d %H:%M:%S")
		)

class DataIpmapHandler(BaseHandler):
	def get(self, minutes):
		try:
			minutes = int(minutes)
		except:
			minutes = 30
		
		from_time = time.time() - 60*minutes
		event_list = get_mac_by_timestamp(min=from_time)

		data_set = set()
		for (mac, _timestamp) in event_list:
			ip_list = get_mac_ips(mac)
			max_timestamp = 0
			last_ip = None
			for ip in ip_list:
				# Skips empty strings and IPv6 addresses
				if ip.count(".") != 3:
					continue
				timestamp = get_mac_ip_timestamp(mac, ip)
				if timestamp > max_timestamp:
					max_timestamp = timestamp
					last_ip = ip
			if last_ip is not None:
				if max_timestamp >= from_time:
					data_set.add(ip2long(last_ip))

		self.render(
			"data.json",
			data = list(data_set)
		)

def main():
	load_options()
	http_server = tornado.httpserver.HTTPServer(Application())
	http_server.listen(options.port, options.host)
	logger.info("(*) Server started on %s:%d", options.host, options.port)
	tornado.ioloop.IOLoop.instance().start()

if __name__ == "__main__":
	main()
