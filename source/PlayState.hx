package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;

class PlayState extends FlxState
{
	var _baseUnit : Int = 64;
	public var _tHeight : Int = 12;
	public var _tWidth : Int = 20;
	public var ground : Array<Array<Tile>>;

	// Player
	var _player1 : Player;
	var _player2 : Player;

	// Territory
	var _fireTileCount: Int;
	var _waterTileCount: Int;

	public var _players : FlxTypedGroup<Player>;

	// UI
	var _hud : HUD;
	var _btnPause : FlxButton;

	// Timer
	public var _timer : FlxTimer;

	// Is game finished
	var _isGameEnd: Bool;
	var rand : FlxRandom;


	override public function create():Void
	{
		FlxG.mouse.visible = false;
		FlxG.debugger.visible = true;
		generateLevel();
		_player1 = new Player(this, Bomb.BombType.Fire, 64, 64);
		add(_player1);
		_player2 = new Player(this, Bomb.BombType.Water, (_tWidth-2)*64, (_tHeight-2)*64);
		add(_player2);

		_players = new FlxTypedGroup<Player>();
		_players.add(_player1);
		_players.add(_player2);

		// HUD info
		_hud = new HUD();
		add(_hud);

		// Pause button
		_btnPause = new FlxButton(0, 0,"Pause", clickPause);
		add(_btnPause);

		// Set up timer
		_timer = new FlxTimer();
		_timer.start(180, onTimerComplete);

		// Set up counter for territory
		_fireTileCount = 0;
		_waterTileCount = 0;

		_isGameEnd = false;

		super.create();
	}

	// Callback functions invoked when time is up
    function onTimerComplete(Timer:FlxTimer) : Void {
		_isGameEnd = true;
    }

	function clickPause(): Void {
		var _pauseState: SubState = new SubState(0x99808080);
		_timer.active = false;
		openSubState(_pauseState);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_fireTileCount = 0;
		_waterTileCount = 0;

		for (i in 0..._tHeight)
        {
			for (j in 0..._tWidth)
			{
				if (ground[i][j].type == Tile.TileType.Unwalkable)
					FlxG.collide(_players, ground[i][j]);

				if (ground[i][j].type == Tile.TileType.Fire) {
					_fireTileCount++;
				}

				if (ground[i][j].type == Tile.TileType.Water) {
					_waterTileCount++;
				}
			}
		}

		for (i in 0..._player1.bombs.length) {
			FlxG.collide(_players, _player1.bombs[i]);
		}
		for (i in 0..._player2.bombs.length) {
			FlxG.collide(_players, _player2.bombs[i]);
		}

		_hud.updateHUD(_player1._currentBombCount, _player2._currentBombCount,_fireTileCount, _waterTileCount, _timer.timeLeft);

		if (_isGameEnd) {
			// jump to Salamander winning screen
			if (_fireTileCount > _waterTileCount) {
				FlxG.switchState(new ResultState("Salamander Win!"));
			}
			// jump to Turtle winning screen
			else if (_waterTileCount > _fireTileCount) {
				FlxG.switchState(new ResultState("Turtle Win!"));
			}
			// jump to draw screen
			else {
				FlxG.switchState(new ResultState("Draw"));
			}
		}
	}

	// Should be somehow randomized later
	public function generateLevel() : Void
    {
		ground = new Array<Array<Tile>>();
        for (col in 0..._tHeight)
        {
			ground.push(new Array<Tile>());
			//split the level into 4 quadrants for level generation
			//There are 4 generic quadrants from which we generate various levels
			//The generic tiles only differ by the initial placement of the refill tiles
			//this method is in progress

			for (row in 0..._tWidth) {
				if (row == col == 0) { //for now water and fire sources are just in corners
					ground[i].push(new Tile(Tile.TileType.WSource, row * _baseUnit, col*_baseUnit));
				} else if ( col == (_tHeight-1) && row == (_tWidth - 1)) {
					ground[i].push(new Tile(Tile.TileType.FSource, row * _baseUnit, col*_baseUnit));
				} else if ( row == 0 || col == 0 || row == (t_Width-1 ) || col ==t_Height-1) { //borders have no walls
					ground[i].push(new Tile(Tile.TileType.Regular, row*_baseUnit, col*_baseUnit));
				} else {
					var tileNum: Int = rand.int(Tile.totalTileTypes);
				}
			}
			// ground.push(new Array<Tile>());
            // for (j in 0..._tWidth)
            // {
            //     if (i==0 || i==(_tHeight-1) || j==0 || j==(_tWidth-1))
            //     {
            //         ground[i].push(new Tile(Tile.TileType.Unwalkable, j*_baseUnit, i*_baseUnit));
            //         add(ground[i][j]);
            //     }
			// 	else
			// 	{
			// 		if (i==1 && j==1) {
			// 			ground[i].push(new Tile(Tile.TileType.FSource, j*_baseUnit, i*_baseUnit));
			// 		}
			// 		else if (i==(_tHeight-2) && j==(_tWidth-2)) {
			// 			ground[i].push(new Tile(Tile.TileType.WSource, j*_baseUnit, i*_baseUnit));
			// 		}
			// 		else {
			// 			ground[i].push(new Tile(Tile.TileType.Regular, j*_baseUnit, i*_baseUnit));
			// 		}
            //         add(ground[i][j]);
			// 	}
            // }
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
