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
        _playState.add(this);
    }

    // Callback functions invoked when time is up
    function onTimerComplete(Timer:FlxTimer) : Void {
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
}