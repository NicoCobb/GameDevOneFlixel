package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

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
     var _sndExplosion: FlxSound;

    public function new(p:Player, ps:PlayState, t:BombType, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X, Y, SimpleGraphic);
        _playState = ps;
        type = t;
        _exploreTime = 1.25;
        _timer = new FlxTimer();
        _player = p;
        switch (type) {
            case Water:
                //makeGraphic(64, 64, FlxColor.CYAN);
                loadGraphic(AssetPaths.TurtleEggAnimationSheet__png, true, 64, 64);
                animation.add("idle", [0, 1, 2, 3], 10, true);
                //loadGraphic(AssetPaths.SplashAnimationsheet__png, true, 192, 192);
                //animation.add("explode", [0, 1, 2, 3], 10, false);
            case Fire:
                //makeGraphic(64, 64, FlxColor.MAGENTA);
                loadGraphic(AssetPaths.SalamanderEggAnimationsheet__png, true, 64, 64);
                animation.add("idle", [0, 1, 2, 3], 10, true);
                //loadGraphic(AssetPaths.ExplosionAnimationsheet__png, true, 192, 192);
                //animation.add("explode", [0, 1, 2, 3], 10, false);
            default:
        }

        // If we want bomb-pushing feature, we can set it to false
        immovable = true;
        _timer.start(_exploreTime, onExplode);
        _sndExplosion = FlxG.sound.load(AssetPaths.bombExplode__wav);

        animation.play("idle");
    }

    // Callback functions invoked when time is up
    function onExplode(Timer:FlxTimer) : Void {
        overtakeTile();
        explode();
        Timer.start(0.3, onRemove);
    }

    function onRemove(Timer:FlxTimer) : Void {
        _player.bombs.remove(this);
        _playState.remove(this);
    }

    function explode() : Void {
        // Load explosion visual effect
        switch (type) {
            case Water:
                loadGraphic(AssetPaths.SplashAnimationsheet__png, true, 192, 192);
                animation.add("explode", [0, 1, 2, 3], 14, false);
            case Fire:
                loadGraphic(AssetPaths.ExplosionAnimationsheet__png, true, 192, 192);
                animation.add("explode", [0, 1, 2, 3], 14, false);
            default:
        }

        // adjust hitbox
        width = 64;
        height = 64;
        offset.set(64, 64);

        // Up
        new Explode(Player.Forward.up, type, _playState, x, y-64);
        //new Explode(Player.Forward.up, type, _playState, x, y-64*2);
        // Down
        new Explode(Player.Forward.down, type, _playState, x, y+64);
        //new Explode(Player.Forward.down, type, _playState, x, y+64*2);
        // Left
        new Explode(Player.Forward.left, type, _playState, x-64, y);
        //new Explode(Player.Forward.left, type, _playState, x-64*2, y);
        // Right
        new Explode(Player.Forward.right, type, _playState, x+64, y);
        //new Explode(Player.Forward.right, type, _playState, x+64*2, y);

        _sndExplosion.play();
        animation.play("explode");
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

    function overtakeTile(): Void {
        // Overtake this tile
        var tileX = Math.round(y / 64);
        var tileY = Math.round(x / 64);
        if (tileX < 0 || tileY <0 || tileX >= _playState._tHeight || tileY >= _playState._tWidth) {
            return;
        }
        if (_playState.ground[tileX][tileY].type != Tile.TileType.Unwalkable && 
        _playState.ground[tileX][tileY].type != Tile.TileType.WSource &&
        _playState.ground[tileX][tileY].type != Tile.TileType.FSource) {
            switch (type) {
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