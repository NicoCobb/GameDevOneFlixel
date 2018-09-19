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
                makeGraphic(20, 20, FlxColor.GREEN);
            case Unwalkable:
                makeGraphic(20, 20, FlxColor.WHITE);
            case Water:
                makeGraphic(20, 20, FlxColor.BLUE);
            case Fire:
                makeGraphic(20, 20, FlxColor.RED);
            case FSource:
                makeGraphic(60, 60, FlxColor.RED);
            case WSource:
                makeGraphic(60, 60, FlxColor.BLUE);
            default:
        }
     }
 }