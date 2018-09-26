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
    public static var totalTileTypes:Int = 6; 

     public function new(t:TileType, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X, Y, SimpleGraphic);
        loadGraphic(AssetPaths.Tileset1__png, true, 64, 64);
        type = t;
        switch (type) {
            case Regular:
                animation.add("idle",[3], 10, true);
                //makeGraphic(64, 64, FlxColor.GREEN);
            case Unwalkable:
                animation.add("idle",[0], 10, true);
                //makeGraphic(64, 64, FlxColor.WHITE);
            case Water:
                animation.add("idle",[4], 10, true);
                //makeGraphic(64, 64, FlxColor.BLUE);
            case Fire:
                animation.add("idle",[1], 10, true);
                //makeGraphic(64, 64, FlxColor.RED);
            case FSource:
                animation.add("idle",[2], 10, true);
                //makeGraphic(64, 64, FlxColor.RED);
            case WSource:
                animation.add("idle",[5], 10, true);
                //makeGraphic(64, 64, FlxColor.BLUE);
            default:
        }
        immovable = true;
        animation.play("idle");
     }
 }