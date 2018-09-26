package;

import flixel.FlxState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import lime.math.Vector2;

class PlayState extends FlxState
{
	public var _baseUnit : Int = 64;
	public var _tHeight : Int = 12;
	public var _tWidth : Int = 20;
	public var ground : Array<Array<Tile>>;

	// Player
	var _player1 : Player;
	var _player2 : Player;
	public var p1Start : Vector2 = new Vector2(0,0);
	public var p2Start : Vector2 = new Vector2(0,0);

	// Territory
	var _fireTileCount: Int;
	var _waterTileCount: Int;

	public var _players : FlxTypedGroup<Player>;

	// UI
	var _hud : HUD;
	var _btnPause : FlxButton;

	// Timer
	public var _timer : FlxTimer;
	var _gameDuration : Int = 120;

	// Is game finished
	var _isGameEnd: Bool;

	// Add bounds
	var upBound: InvisibleBound;
	var downBound: InvisibleBound;
	var leftBound: InvisibleBound;
	var rightBound: InvisibleBound;

	override public function create():Void
	{
		FlxG.mouse.visible = false;
		FlxG.debugger.visible = true;
		FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
		camera = new FlxCamera(0, 0, 64*_tWidth, 64*_tHeight);
		generateLevel();
		_player1 = new Player(this, Bomb.BombType.Fire, p1Start.y*64, p1Start.x*64);
		add(_player1);
		_player2 = new Player(this, Bomb.BombType.Water, p2Start.y*64, p2Start.x*64);
		add(_player2);

		_players = new FlxTypedGroup<Player>();
		_players.add(_player1);
		_players.add(_player2);

		// HUD info
		_hud = new HUD();
		add(_hud);

		// Pause button
		_btnPause = new FlxButton(0, 0,"", clickPause);
		// _btnPause.loadGraphic("assets/images/PauseButton.png", false, 40, 40);
		_btnPause.visible = false;
		add(_btnPause);

		// Set up timer
		_timer = new FlxTimer();
		_timer.start(_gameDuration, onTimerComplete, 1);

		// Set up counter for territory
		_fireTileCount = 0;
		_waterTileCount = 0;

		_isGameEnd = false;

		// Bounds
		upBound = new InvisibleBound(64, 64*(_tWidth+2), -64, -64);
		downBound = new InvisibleBound(64, 64*(_tWidth+2), -64, 64*_tHeight);
		leftBound = new InvisibleBound(64 * _tHeight, 64, -64, 0);
		rightBound = new InvisibleBound(64 * _tHeight, 64, 64 * _tWidth, 0);

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
		if (FlxG.keys.justPressed.ESCAPE) {
			clickPause();
		}

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

		// Collision with bounds
		FlxG.collide(_players, upBound);
		FlxG.collide(_players, downBound);
		FlxG.collide(_players, leftBound);
		FlxG.collide(_players, rightBound);

		_hud.updateHUD(_player1._currentBombCount, _player2._currentBombCount,_fireTileCount, _waterTileCount, _timer.timeLeft);

		if (_isGameEnd) {
			FlxG.camera.fade(FlxColor.BLACK, 0.1, false, function(){
            	FlxG.switchState(new GameOverState(_fireTileCount, _waterTileCount));
        	});
		}
	}

	// Should be somehow randomized later
	public function generateLevel() : Void
    {
		//basic grasslands with start tiles
		// ground = new Array<Array<Tile>>();
        // for (i in 0..._tHeight)
        // {
		// 	ground.push(new Array<Tile>());
        //     for (j in 0..._tWidth)
        //     {
        //         if (i==0 || i==(_tHeight-1) || j==0 || j==(_tWidth-1))
        //         {
        //             ground[i].push(new Tile(Tile.TileType.Unwalkable, j*_baseUnit, i*_baseUnit));
        //             add(ground[i][j]);
        //         }
		// 		else
		// 		{
		// 			if (i==1 && j==1) {
		// 				ground[i].push(new Tile(Tile.TileType.FSource, j*_baseUnit, i*_baseUnit));
		// 			}
		// 			else if (i==(_tHeight-2) && j==(_tWidth-2)) {
		// 				ground[i].push(new Tile(Tile.TileType.WSource, j*_baseUnit, i*_baseUnit));
		// 			}
		// 			else {
		// 				ground[i].push(new Tile(Tile.TileType.Regular, j*_baseUnit, i*_baseUnit));
		// 			}
        //             add(ground[i][j]);
		// 		}
        //     }
		// }

		//pseudo random levels: columns and rows version
		ground = new Array<Array<Tile>>();
		//first populate as all grass
        for (i in 0..._tHeight)
        {
			ground.push(new Array<Tile>());
            for (j in 0..._tWidth)
            {
				ground[i].push(new Tile(Tile.TileType.Regular, j*_baseUnit, i*_baseUnit));
                add(ground[i][j]);
            }
		}
		//then select from one of 5 basic start shapes
		var seedNum : Int = FlxG.random.int(0,4);
		switch(seedNum) {
			case 0:
				p1Start.setTo(0, 0);
				replaceTile(0, 0, Tile.TileType.FSource);
				p2Start.setTo((_tHeight - 1), (_tWidth - 1));
				replaceTile((_tHeight - 1), (_tWidth - 1), Tile.TileType.WSource);
			case 1:
				p1Start.setTo((_tHeight - 1), 0);
				replaceTile((_tHeight - 1), 0, Tile.TileType.FSource);
				p2Start.setTo(0,(_tWidth - 1));
				replaceTile(0,(_tWidth - 1), Tile.TileType.WSource);

			case 2:
				p1Start.setTo(0,8);
				replaceTile(0, 8, Tile.TileType.FSource);
				p2Start.setTo(0,11);
				replaceTile(0,11,Tile.TileType.WSource);

			case 3:
				p1Start.setTo(11,8);
				replaceTile(11, 8, Tile.TileType.FSource);
				p2Start.setTo(11,11);
				replaceTile(11,11,Tile.TileType.WSource);

			case 4:
				p1Start.setTo(6,8);
				replaceTile(6,8,Tile.TileType.FSource);
				p2Start.setTo(6,11);
				replaceTile(6,11,Tile.TileType.WSource);

			default:
				//no default
		}
		//if false, walls can only generate on odd rows
		//if true, walls can only generate on odd cols
		//will try to get a better algorithm if possible but I know this makes playable levels
		var useOddCols : Bool = FlxG.random.bool();
		for (i in 0..._tHeight) {
			for (j in 0..._tWidth) {
				if (ground[i][j].type == Tile.TileType.WSource || ground[i][j].type == Tile.TileType.FSource)
					continue;
				else if (useOddCols && (j % 2 == 1)) {
					var isWall : Bool = FlxG.random.bool(55);
					if (isWall)
						replaceTile(i, j, Tile.TileType.Unwalkable);
				}
				else if (!useOddCols && (i % 2 == 1)) {
					var isWall : Bool = FlxG.random.bool(53);
					if (isWall)
						replaceTile(i, j, Tile.TileType.Unwalkable);
				}
			}
		}

		//safety check: check cols or rows and make sure there is at least one opening
		if(useOddCols) {
			var j : Int = 1;
			while(j < _tWidth) {
				var isPassable: Bool = false;
				for(i in 0..._tHeight) {
					if (ground[i][j].type == Tile.TileType.Regular)
						isPassable = true;
				}
				if(!isPassable) {
					var randLocation = FlxG.random.int(0, (_tHeight - 1));
					replaceTile(randLocation, j, Tile.TileType.Regular);
				}
				j += 2;
			}
		} else {
			var i : Int = 1;
			while(i < _tHeight) {
				var isPassable: Bool = false;
				for(j in 0..._tWidth) {
					if (ground[i][j].type == Tile.TileType.Regular)
						isPassable = true;
				}
				if(!isPassable) {
					var randLocation = FlxG.random.int(0, (_tWidth - 1));
					replaceTile(i, randLocation, Tile.TileType.Regular);
				}
				i += 2;
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

	private function replaceTile(row: Int, col: Int, targetType : Tile.TileType) : Void
	{
		remove(ground[row][col]);
		ground[row][col] = new Tile(targetType, col*_baseUnit, row*_baseUnit);
		add(ground[row][col]);
	}

	public function cameraShake(): Void
	{
		FlxG.camera.shake(0.003, 0.3);
	}
}
