package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class Explode extends FlxSprite {
    var _playState: PlayState;
    var _timer: FlxTimer;
    var _bombType: Bomb.BombType;
    var _direction: Player.Forward;

    public function new(d: Player.Forward, bType: Bomb.BombType, ps: PlayState, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X, Y, SimpleGraphic);
        _playState = ps;
        _timer = new FlxTimer();
        _timer.start(0.3, onTimerComplete);
        _bombType = bType;
        _direction = d;
        switch (_bombType) {
            case Bomb.BombType.Fire:
                makeGraphic(64, 64, FlxColor.MAGENTA);
            case Bomb.BombType.Water:
                makeGraphic(64, 64, FlxColor.CYAN);
            default:
        }
        immovable = true;
        alpha = 0;
        _playState.add(this);
    }

    // Callback functions invoked when time is up
    function onTimerComplete(Timer:FlxTimer) : Void {
        overtakeTile();
        _playState.remove(this);
    }

    override public function update(elapsed:Float) : Void
    {
        // Push back effect
        for (i in 0..._playState._players.members.length) {
            if (_bombType != _playState._players.members[i]._bombType) {
                FlxG.overlap(this, _playState._players.members[i], onOverlap);
            }
        }
        super.update(elapsed);
    }

    function onOverlap(object1:FlxObject, object2:FlxObject) : Void {
        var player = cast (object2, Player);
        player.pushBack(_direction);
    }

    // Overtake this tile
    function overtakeTile(): Void {
        var tileX = Math.round(y / 64);
        var tileY = Math.round(x / 64);
        if (tileX < 0 || tileY <0 || tileX >= _playState._tHeight || tileY >= _playState._tWidth) {
            return;
        }
        if (_playState.ground[tileX][tileY].type != Tile.TileType.Unwalkable) {
            switch (_bombType) {
                case Bomb.BombType.Fire:
                    if (_playState.ground[tileX][tileY].type != Tile.TileType.Fire) {
                        _playState.remove(_playState.ground[tileX][tileY]);
                        _playState.ground[tileX][tileY] = new Tile(Tile.TileType.Fire, tileY*64, tileX*64);
                        _playState.add(_playState.ground[tileX][tileY]);
                    }
                case Bomb.BombType.Water:
                    if (_playState.ground[tileX][tileY].type != Tile.TileType.Water) {
                        _playState.remove(_playState.ground[tileX][tileY]);
                        _playState.ground[tileX][tileY] = new Tile(Tile.TileType.Water, tileY*64, tileX*64);
                        _playState.add(_playState.ground[tileX][tileY]);
                    }
                default:
            }
        }
    }
}