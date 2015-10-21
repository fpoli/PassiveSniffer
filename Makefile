TSHARK_ARGS = -q -i $${IFACE:-"eth0"}

.PHONY: default sniffer sniffer-debug server update-lua-lib clean

default: sniffer

sniffer:
	@echo "Starting sniffer..."
	@tshark -X lua_script:main.lua ${TSHARK_ARGS} 2>/dev/null
	@echo "Done."

sniffer-debug:
	@echo "Starting sniffer in debug mode..."
	@tshark -X lua_script:main.lua ${TSHARK_ARGS}
	@echo "Done."

server:
	@echo "Starting server..."
	@python server.py
	@echo "Done."

update-lua-lib:
	@echo "Downloading Redis lua lib..."
	@wget https://raw.github.com/nrk/redis-lua/version-2.0/src/redis.lua -O lua/redis.lua
	@echo "Downloading JSON lua lib..."
	@wget http://regex.info/code/JSON.lua -O lua/json.lua
	@echo "Done."

clean:
	rm -f *~ */*~ */*/*~
