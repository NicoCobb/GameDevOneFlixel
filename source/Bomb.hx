package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxColor;

enum BombType {
    Water;
    Fire;
}

class Tile extends FlxSprite{
    public var type: BombType;

    public function new(t:BombType, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X, Y, SimpleGraphic);
    }
}