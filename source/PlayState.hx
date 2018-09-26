package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

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
	var _gameDuration : Int = 180;

	// Is game finished
	var _isGameEnd: Bool;


	override public function create():Void
	{
		FlxG.mouse.visible = true;
		FlxG.debugger.visible = true;
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
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
		_btnPause = new FlxButton(0, 0,"", clickPause);
		_btnPause.loadGraphic("assets/images/PauseButton.png", false, 40, 40);
		add(_btnPause);

		// Set up timer
		_timer = new FlxTimer();
		_timer.start(_gameDuration, onTimerComplete);

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
			FlxG.switchState(new GameOverState(_fireTileCount, _waterTileCount));
		}
	}

	// Should be somehow randomized later
	public function generateLevel() : Void
    {
		ground = new Array<Array<Tile>>();
        for (i in 0..._tHeight)
        {
			ground.push(new Array<Tile>());
            for (j in 0..._tWidth)
            {
                if (i==0 || i==(_tHeight-1) || j==0 || j==(_tWidth-1))
                {
                    ground[i].push(new Tile(Tile.TileType.Unwalkable, j*_baseUnit, i*_baseUnit));
                    add(ground[i][j]);
                }
				else
				{
					if (i==1 && j==1) {
						ground[i].push(new Tile(Tile.TileType.FSource, j*_baseUnit, i*_baseUnit));
					}
					else if (i==(_tHeight-2) && j==(_tWidth-2)) {
						ground[i].push(new Tile(Tile.TileType.WSource, j*_baseUnit, i*_baseUnit));
					}
					else {
						ground[i].push(new Tile(Tile.TileType.Regular, j*_baseUnit, i*_baseUnit));
					}
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
