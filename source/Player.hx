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

     var _bombType:Bomb.BombType;
     var _maxBombCount:Int;
     var _currentBombCount:Int;

     public function new(bombType:Bomb.BombType, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
     {
         super(X, Y, SimpleGraphic);
         _bombType = bombType;         
         switch (_bombType) {
             case Bomb.BombType.Fire:
                makeGraphic(64, 64, FlxColor.MAGENTA);
             case Bomb.BombType.Water:
                makeGraphic(64, 64, FlxColor.CYAN);
         }
         drag.x = 100;
         drag.y = 100;

         _maxBombCount = 3;
         _currentBombCount = 0;
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

        // 1st player
        if (_bombType == Bomb.BombType.Fire) {
            
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
        }
        
        // 2nd player, doesn't work, don't know why
        if (_bombType == Bomb.BombType.Water) {
            
            if (_right = FlxG.keys.anyPressed([RIGHT])) 
            {
                velocity.set(_speed * elapsed, 0);
            }
            else if (_left = FlxG.keys.anyPressed([LEFT])) 
            {
                velocity.set(-_speed * elapsed, 0);
            }
            else if (_down = FlxG.keys.anyPressed([DOWN])) 
            {
                velocity.set(0, _speed * elapsed);
            }
            else if (_up = FlxG.keys.anyPressed([UP])) 
            {
                velocity.set(0, -_speed * elapsed);
            }
        }

        super.update(elapsed);
     }

    // Invoke when player withdraw bombs
     public function withdrawBombs() {
         _currentBombCount = _maxBombCount;
     }
 }