# PassiveSniffer

Purely passive traffic analyzer, aimed at analyzing private LANs.

The backend sniffs broadcast packets using a Lua script running in Tshark,
and stores relevant information in a Redis database
(discarding packets coming from public IPs).

The frontend is a simple website written in Python (tornado) that displays
the information collected in the last X minutes (X=30 by default),
grouping them by MAC address and IP.

## Requirements

- Python
    - tornado
    - python-redis
- Redis
- Tshark
- LuaSocket

On Ubuntu 14.04 you can install them by running
```
apt-get install	python-tornado python-redis redis-server tshark lua-socket
```

## Usage

- Start Redis server: `service redis-server start`
- Start sniffer: `make sniffer` or `IFACE=wlan0 make sniffer` (`make sniffer-debug` for debugging)
- Start server: `make server`
- View results at http://localhost:8888
