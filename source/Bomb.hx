package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

enum BombType {
    Water;
    Fire;
}

class Bomb extends FlxSprite{
    public var type: BombType;
     var _playState:PlayState;
     var _exploreTime: Float;
     var _timer: FlxTimer;
     var _player: Player;

    public function new(p:Player, ps:PlayState, t:BombType, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X, Y, SimpleGraphic);
        _playState = ps;
        type = t;
        _exploreTime = 3;
        _timer = new FlxTimer();
        _player = p;
        switch (type) {
            case Water:
                makeGraphic(64, 64, FlxColor.CYAN);
            case Fire:
                makeGraphic(64, 64, FlxColor.MAGENTA);
            default:
        }

        // If we want bomb-pushing feature, we can set it to false
        immovable = true;
        _timer.start(_exploreTime, onExplode);
    }

    // Callback functions invoked when time is up
    function onExplode(Timer:FlxTimer) : Void {
        explode();
        Timer.start(0.3, onRemove);
    }

    function onRemove(Timer:FlxTimer) : Void {
        _player.bombs.remove(this);
        _playState.remove(this);
    }

    function explode() : Void {
        // Up
        new Explode(Player.Forward.up, type, _playState, x, y-64);
        new Explode(Player.Forward.up, type, _playState, x, y-64*2);
        // Down
        new Explode(Player.Forward.down, type, _playState, x, y+64);
        new Explode(Player.Forward.down, type, _playState, x, y+64*2);
        // Left
        new Explode(Player.Forward.left, type, _playState, x-64, y);
        new Explode(Player.Forward.left, type, _playState, x-64*2, y);
        // Right
        new Explode(Player.Forward.right, type, _playState, x+64, y);
        new Explode(Player.Forward.right, type, _playState, x+64*2, y);
    }

    override public function update(elapsed:Float) : Void
    {
        // if(FlxG.keys.pressed.D) 
        // {
        //     animation.play("walk");
        // }
        // else 
        // {
        //     animation.stop();
        // }

        super.update(elapsed);
    }
}