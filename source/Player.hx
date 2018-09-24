 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.FlxG;
 import flixel.util.FlxColor;
 import flixel.input.keyboard.FlxKey;
 import flixel.text.FlxText;
 import flixel.util.FlxTimer;

 enum Forward {
     up;
     down;
     left;
     right;
 }

 class Player extends FlxSprite
 {
     var _speed : Float = 3200;
     var _slowSpeed : Float = 2400;
     var _pushBackSpeed: Float = 1000;
     var _forward:Forward;

     public var _bombType:Bomb.BombType;
     var _maxBombCount:Int;
     var _currentBombCount:Int;
     public var bombs: Array<Bomb>;

     var _playState:PlayState;

     // Handle push back
     var _isPushingBack: Bool;
     var _pushBackTimer: FlxTimer;

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
         _pushBackSpeed = 1000;

         _maxBombCount = 3;
         _currentBombCount = 5;

         _isPushingBack = false;
         _pushBackTimer = new FlxTimer();

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

        var tileXmin = Math.floor(y / 64.0);
        var tileXmax = Math.ceil(y / 64.0);
        var tileYmin = Math.floor(x / 64.0);
        var tileYmax = Math.ceil(x / 64.0);
        var _s = _speed;

        // 1st player
        if (_bombType == Bomb.BombType.Fire) {

            // Check if player is on opponent's territory
            
            if (_playState.ground[tileXmin][tileYmin].type == Tile.TileType.Water ||
            _playState.ground[tileXmin][tileYmax].type == Tile.TileType.Water ||
            _playState.ground[tileXmax][tileYmin].type == Tile.TileType.Water ||
            _playState.ground[tileXmax][tileYmax].type == Tile.TileType.Water) {
                _s = _slowSpeed;
            }
            
            if (!_isPushingBack) {
                if (FlxG.keys.anyPressed([D]))
                {
                    velocity.set(_s * elapsed, 0);
                    _forward = Forward.right;
                }
                else if (FlxG.keys.anyPressed([A]))
                {
                    velocity.set(-_s * elapsed, 0);
                    _forward = Forward.left;
                }
                else if (FlxG.keys.anyPressed([S]))
                {
                    velocity.set(0, _s * elapsed);
                    _forward = Forward.down;
                }
                else if (FlxG.keys.anyPressed([W]))
                {
                    velocity.set(0, -_s * elapsed);
                    _forward = Forward.up;
                }
            }

            if (FlxG.keys.anyJustPressed([G])) {
                douseBomb();
            }
        }
        
        // 2nd player, doesn't work, don't know why
        if (_bombType == Bomb.BombType.Water) {
            
            if (_playState.ground[tileXmin][tileYmin].type == Tile.TileType.Fire ||
            _playState.ground[tileXmin][tileYmax].type == Tile.TileType.Fire ||
            _playState.ground[tileXmax][tileYmin].type == Tile.TileType.Fire ||
            _playState.ground[tileXmax][tileYmax].type == Tile.TileType.Fire) {
                _s = _slowSpeed;
            }

            if (!_isPushingBack) {
                if (FlxG.keys.anyPressed([RIGHT]))
                {
                    velocity.set(_s * elapsed, 0);
                    _forward = Forward.right;
                }
                else if (FlxG.keys.anyPressed([LEFT])) 
                {
                    velocity.set(-_s * elapsed, 0);
                    _forward = Forward.left;
                }
                else if (FlxG.keys.anyPressed([DOWN]))
                {            
                    velocity.set(0, _s * elapsed);
                    _forward = Forward.down;
                }
                else if (FlxG.keys.anyPressed([UP]))
                {            
                    velocity.set(0, -_s * elapsed);
                    _forward = Forward.up;
                }
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
             var tempX : Int;
             var tempY : Int;
             switch (_forward) {
                 case Forward.down:
                    tempX = Math.round(x / 64.0);
                    tempY = Math.round(y / 64.0) + 1;
                 case Forward.up:
                    tempX = Math.round(x / 64.0);
                    tempY = Math.round(y / 64.0) - 1;
                 case Forward.left:
                    tempY = Math.round(y / 64.0);
                    tempX = Math.round(x / 64.0) - 1;
                 case Forward.right:
                    tempY = Math.round(y / 64.0);
                    tempX = Math.round(x / 64.0) + 1;
            }

            // Check the validity
            if (_playState.ground[tempY][tempX].type == Tile.TileType.Unwalkable) {
                return;
            }
            tempBomb = new Bomb(this, _playState, _bombType, tempX*64, tempY*64);
            _playState.add(tempBomb);
            bombs.push(tempBomb);
            _currentBombCount--;
         }
     }

     // Push back function
     public function pushBack(dir:Forward) {
         _isPushingBack = true;
         switch (dir) {
             case Forward.left:
                velocity.set(-_pushBackSpeed, 0);
             case Forward.right:
                velocity.set(_pushBackSpeed, 0);
             case Forward.up:
                velocity.set(0, -_pushBackSpeed);
             case Forward.down:
                velocity.set(0, _pushBackSpeed);
             default:

         }
        _forward = dir;
        _pushBackTimer.start(1, onPushBackComplete);
     }

     function onPushBackComplete(Timer:FlxTimer) : Void {
         _isPushingBack = false;
     }
 }