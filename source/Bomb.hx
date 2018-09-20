package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxColor;

enum BombType {
    Water;
    Fire;
}

class Bomb extends FlxSprite{
    public var type: BombType;

    public function new(t:BombType, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X, Y, SimpleGraphic);

        type = t;
        switch (type) {
            case Water:
                makeGraphic(64, 64, FlxColor.CYAN);
            case Fire:
                makeGraphic(64, 64, FlxColor.MAGENTA);
            default:
        }

        // If we want bomb-pushing feature, we can set it to false
        immovable = true;
    }
}