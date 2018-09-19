 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.FlxG;
 import flixel.util.FlxColor;

enum TileType {
    Regular;
    Unwalkable;
    Water;
    Fire;
    FSource;
    WSource;
}

class Tile extends FlxSprite{
     public function new(type:TileType, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X, Y, SimpleGraphic);
        switch (type) {
            case Regular:
                makeGraphic(32, 32, FlxColor.GREEN);
            case Unwalkable:
                makeGraphic(32, 32, FlxColor.WHITE);
            case Water:
                makeGraphic(32, 32, FlxColor.BLUE);
            case Fire:
                makeGraphic(32, 32, FlxColor.RED);
            case FSource:
                makeGraphic(32, 32, FlxColor.RED);
            case WSource:
                makeGraphic(128, 128, FlxColor.BLUE);
            default:
        }
     }
 }