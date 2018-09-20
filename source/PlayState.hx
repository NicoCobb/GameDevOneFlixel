package;

import flixel.FlxState;
import flixel.FlxG;

class PlayState extends FlxState
{
	var _baseUnit : Int = 64;
	var _tHeight : Int = 12;
	var _tWidth : Int = 20;
	var ground = [];

	// Player 
	var _player1 : Player;
	var _player2 : Player;

	override public function create():Void
	{
		generateLevel();
		_player1 = new Player(Bomb.BombType.Fire, 64, 64);
		_player2 = new Player(Bomb.BombType.Water, (_tWidth-2)*64, (_tHeight-2)*64);
		add(_player1);
		add(_player2);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		for (i in 0..._tHeight)
        {
			for (j in 0..._tWidth)
			{
				if (ground[i][j].type == Tile.TileType.Unwalkable)
					FlxG.collide(_player1, ground[i][j]);
					FlxG.collide(_player2, ground[i][j]);
			}
		}
	}

	// Should be somehow randomized later
	public function generateLevel() : Void
    {
        for (i in 0..._tHeight)
        {
			ground.push([]);
            for (j in 0..._tWidth)
            {	
                if (i==0 || i==(_tHeight-1) || j==0 || j==(_tWidth-1))
                {
                    ground[i].push(new Tile(Tile.TileType.Unwalkable, j*_baseUnit, i*_baseUnit));
                    add(ground[i][j]);
                }
				else
				{
					ground[i].push(new Tile(Tile.TileType.Regular, j*_baseUnit, i*_baseUnit));
                    add(ground[i][j]);
				}
            }
        }

/*
        _regularTile = new Tile(Tile.TileType.Regular, 32, 32);
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
        */
    }
}
