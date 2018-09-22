 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.FlxG;
 import flixel.util.FlxColor;
 import flixel.input.keyboard.FlxKey;
 import flixel.text.FlxText;

 enum Forward {
     up;
     down;
     left;
     right;
 }

 class Player extends FlxSprite
 {
     var _speed : Float = 3200;

     var _forward:Forward;

     var _bombType:Bomb.BombType;
     var _maxBombCount:Int;
     var _currentBombCount:Int;
     public var bombs: Array<Bomb>;

     var _playState:PlayState;

    // Debugging purpose
     var myText:FlxText;

     public function new(_ps:PlayState, bombType:Bomb.BombType, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
     {
         super(X, Y, SimpleGraphic);
         _playState = _ps;
         _bombType = bombType;
         switch (_bombType) {
             case Bomb.BombType.Fire:
                makeGraphic(64, 64, FlxColor.MAGENTA);
                _forward = Forward.right;
             case Bomb.BombType.Water:
                makeGraphic(64, 64, FlxColor.CYAN);
                _forward = Forward.left;
         }
         bombs = new Array<Bomb>();
         drag.x = 100;
         drag.y = 100;
         _speed = 3200;

         _maxBombCount = 3;
         _currentBombCount = 3;

         myText = new FlxText(110, 100, 500);
        myText.text = "";
        myText.setFormat("assets/font.ttf", 20, FlxColor.WHITE, "center");

        _playState.add(myText);
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

        movement(elapsed);

        super.update(elapsed);
     }

    // Invoke when player withdraws bombs
     public function withdrawBombs() {
         _currentBombCount = _maxBombCount;
     }

     public function movement(elapsed:Float) {
        // 1st player
        if (_bombType == Bomb.BombType.Fire) {
            
            if (FlxG.keys.anyPressed([D]))
            {
                velocity.set(_speed * elapsed, 0);
                _forward = Forward.right;
            }
            else if (FlxG.keys.anyPressed([A]))
            {
                velocity.set(-_speed * elapsed, 0);
                _forward = Forward.left;
            }
            else if (FlxG.keys.anyPressed([S]))
            {
                velocity.set(0, _speed * elapsed);
                _forward = Forward.down;
            }
            else if (FlxG.keys.anyPressed([W]))
            {
                velocity.set(0, -_speed * elapsed);
                _forward = Forward.up;
            }

            if (FlxG.keys.anyJustPressed([G])) {
                douseBomb();
            }
        }
        
        // 2nd player, doesn't work, don't know why
        if (_bombType == Bomb.BombType.Water) {
                        
            if (FlxG.keys.anyPressed([RIGHT]))
            {
                velocity.set(_speed * elapsed, 0);
                _forward = Forward.right;
            }
            else if (FlxG.keys.anyPressed([LEFT])) 
            {
                velocity.set(-_speed * elapsed, 0);
                _forward = Forward.left;
            }
            else if (FlxG.keys.anyPressed([DOWN]))
            {            
                velocity.set(0, _speed * elapsed);
                _forward = Forward.down;
            }
            else if (FlxG.keys.anyPressed([UP]))
            {            
                velocity.set(0, -_speed * elapsed);
                _forward = Forward.up;
            }

            if (FlxG.keys.anyJustPressed([NUMPADONE])) {
                douseBomb();
            }
        }
     }

    // Invoke when player douses a bomb
     public function douseBomb() {
         if (_currentBombCount > 0) {
             // spawn if valid
             var tempBomb : Bomb;
             switch (_forward) {
                 case Forward.down:
                    tempBomb = new Bomb(_bombType, x, y+64);
                 case Forward.up:
                    tempBomb = new Bomb(_bombType, x, y-64);
                 case Forward.left:
                    tempBomb = new Bomb(_bombType, x-64, y);
                 case Forward.right:
                    tempBomb = new Bomb(_bombType, x+64, y);
             }
            _playState.add(tempBomb);
            bombs.push(tempBomb);
             _currentBombCount--;
         }
     }
 }