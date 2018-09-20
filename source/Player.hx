 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.FlxG;
 import flixel.util.FlxColor;

 class Player extends FlxSprite
 {
     var _speed : Float = 3200;

     var _up:Bool = false;
     var _down:Bool = false;
     var _left:Bool = false;
     var _right:Bool = false;

     public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
     {
         super(X, Y, SimpleGraphic);
         makeGraphic(64, 64, FlxColor.CYAN);
         drag.x = 100;
         drag.y = 100;
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

        if (_right = FlxG.keys.anyPressed([D])) 
        {
            velocity.set(_speed * elapsed, 0);
        }
        else if (_left = FlxG.keys.anyPressed([A])) 
        {
            velocity.set(-_speed * elapsed, 0);
        }
        else if (_down = FlxG.keys.anyPressed([S])) 
        {
            velocity.set(0, _speed * elapsed);
        }
        else if (_up = FlxG.keys.anyPressed([W])) 
        {
            velocity.set(0, -_speed * elapsed);
        }

        super.update(elapsed);
     }
 }