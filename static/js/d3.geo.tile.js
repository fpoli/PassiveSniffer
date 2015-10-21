d3.geo.tile = function() {
	var size = [960, 500],
		scale = 256,
		tileLevels = 16,
		tileSize = 256,
		translate = [size[0] / 2, size[1] / 2];

	function tile() {
		// scale: (zoom out) 0 <<-->> +inf (zoom in)
		// zoom: 0 = single big tile, 1, 2, ... tileLevels = detailed tiles
		var zoom = Math.min(tileLevels, Math.max(0,
			- Math.ceil(Math.log(scale) / Math.LN2
		)));
		// level: 0 = detailed tiles, 1, 2, ... tileLevels = single big tile
		var level = tileLevels - zoom;
		// Size of the tiles grouped together
		var numTileSide = Math.pow(2, zoom);
		var bigTileSize = numTileSide * tileSize;
		// Number of big-tiles on the side
		var sideLength = Math.pow(2, level);
		// Scaled size of the grouped tiles
		var bigScreenTileSize = bigTileSize * scale;
		var origin = [
			  scale / 2 - translate[0],
			  scale / 2 - translate[1]
		];
		var cols = d3.range(
			Math.max(0, Math.floor(origin[0] / bigScreenTileSize)),
			Math.max(0, Math.ceil((origin[0] + size[0]) / bigScreenTileSize))
		);

		var rows = d3.range(
			Math.max(0, Math.floor(origin[1] / bigScreenTileSize)),
			Math.max(0, Math.ceil((origin[1] + size[1]) / bigScreenTileSize))
		);

		var tiles = [];
		rows.forEach(function(y) {
			cols.forEach(function(x) {
				if (x < sideLength && y < sideLength) {
					tiles.push({
						x: x, 
						y: y,
						level: level,
						zoom: zoom,
						size: bigTileSize
					});
				}
			});
		});

		//tiles.translate = origin;

		return tiles;
	}

	tile.tileLevels = function(_) {
		if (!arguments.length) return tileLevels;
		tileLevels = _;
		return tile;
	};

	tile.tileSize = function(_) {
		if (!arguments.length) return tileSize;
		tileSize = _;
		return tile;
	};

	tile.size = function(_) {
		if (!arguments.length) return size;
		size = _;
		return tile;
	};

	tile.scale = function(_) {
		if (!arguments.length) return scale;
		scale = _;
		return tile;
	};

	tile.translate = function(_) {
		if (!arguments.length) return translate;
		translate = _;
		return tile;
	};

	return tile;
};
