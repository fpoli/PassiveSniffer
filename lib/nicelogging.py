import logging

""" Colored logging output """

# FIXME global is bad
text_blue   = "\033[94m"
text_red	= "\033[91m"
text_yellow = "\033[93m"
text_green  = "\033[92m"
text_gray  = "\033[0;30m"
text_reset  = "\033[0;0m"

class ColoredFilter(logging.Filter):
	def filter(self, record):
		global text_red, text_yellow, text_green, text_gray, text_reset
		
		record.begin = ""
		record.color = ""
		record.reset = text_reset
		if record.levelname == "DEBUG":
			record.begin = "(D) "
			record.color = text_gray
		elif record.levelname == "INFO":
			record.begin = ""
			record.color = ""
		elif record.levelname == "WARNING":
			record.begin = "/!\ "
			record.color = text_yellow
		elif record.levelname == "ERROR":
			record.begin = "/!\ "
			record.color = text_red
		return record


screen = logging.StreamHandler()
screen.setFormatter(logging.Formatter("%(color)s%(begin)s%(message)s%(reset)s"))
screen.setLevel(logging.DEBUG)

logger = logging.getLogger("PassiveSniffer")
logger.propagate = False
logger.addFilter(ColoredFilter())
logger.addHandler(screen)
