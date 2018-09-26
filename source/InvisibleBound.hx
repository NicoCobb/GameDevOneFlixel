 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.FlxG;
 import flixel.util.FlxColor;


class InvisibleBound extends FlxSprite{

    public var type: Tile.TileType;

     public function new(h:Int, w:Int, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X, Y, SimpleGraphic);
        makeGraphic(w, h, FlxColor.WHITE);
        type = Tile.TileType.Unwalkable;
        immovable = true;
        alpha = 0;
     }
 }