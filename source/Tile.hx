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

    public var type:TileType;

     public function new(t:TileType, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X, Y, SimpleGraphic);
        type = t;
        switch (type) {
            case Regular:
                makeGraphic(64, 64, FlxColor.GREEN);
            case Unwalkable:
                makeGraphic(64, 64, FlxColor.WHITE);
            case Water:
                makeGraphic(64, 64, FlxColor.BLUE);
            case Fire:
                makeGraphic(64, 64, FlxColor.RED);
            case FSource:
                makeGraphic(64, 64, FlxColor.RED);
            case WSource:
                makeGraphic(64, 64, FlxColor.BLUE);
            default:
        }
        immovable = true;
     }
 }