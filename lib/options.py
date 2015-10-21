#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
import tornado
from tornado.options import options, define

from nicelogging import logger

define("config", default="/etc/passive-sniffer.conf", help="Configuration file", type=str)

define("db_host", default='localhost', help="Redis host", type=str)
define("db_port", default=6379, help="Redis port", type=int)
define("db_num", default=0, help="Redis database number", type=int)
define("db_unix_socket", default=None, help="Redis unix sochet path", type=str)

define("port", default=8888, help="run web server on the given port", type=int)
define("host", default="0.0.0.0", help="run web server on the given ip", type=str)
define("debug", default=True, type=bool)

def load_options():
	if os.path.isfile(options.config):
		logger.info("(*) Leggo il file di configurazione %s", options.config)
		tornado.options.parse_config_file(options.config)
	tornado.options.parse_command_line()
