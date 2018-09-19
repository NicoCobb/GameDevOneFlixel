package;

import flixel.FlxState;

class PlayState extends FlxState
{
	var _regularTile : Tile;
	var _unwakableTile : Tile;
	var _fireTile : Tile;
	var _waterTile : Tile;
	var _fSourceTile : Tile;
	var _wSourceTile : Tile;

	override public function create():Void
	{
		_regularTile = new Tile(Tile.TileType.Regular, 20, 20);
		_unwakableTile = new Tile(Tile.TileType.Unwalkable, 80, 20);
		_fireTile = new Tile(Tile.TileType.Fire, 140, 20);
		_waterTile = new Tile(Tile.TileType.Water, 200, 20);
		_fSourceTile = new Tile(Tile.TileType.FSource, 260, 20);
		_wSourceTile = new Tile(Tile.TileType.WSource, 320, 20);
		add(_regularTile);
		add(_unwakableTile);
		add(_fireTile);
		add(_waterTile);
		add(_fSourceTile);
		add(_wSourceTile);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
