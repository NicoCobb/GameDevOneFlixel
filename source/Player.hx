 package;

 import flixel.FlxSprite;
 import flixel.system.FlxSound;
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
     var _speed : Float = 40000;
     var _slowSpeed : Float = 30000;
     var _pushBackSpeed: Float = 1000;
     var _forward:Forward;

     public var _bombType:Bomb.BombType;
     var _maxBombCount:Int;
     public var _currentBombCount:Int;
     public var bombs: Array<Bomb>;

     var _playState:PlayState;

     // Handle push back
     var _isPushingBack: Bool;
     var _pushBackTimer: FlxTimer;

    // Debugging purpose
     var myText:FlxText;

     // Sound effect
     var _sndStep: FlxSound;
     var _sndFireStep: FlxSound;
     var _sndWaterStep: FlxSound;
     var _sndPlaceBomb: FlxSound;
     var _sndWithdrawBomb: FlxSound;
     var _sndPushBack: FlxSound;

     // indicate if in withdraw
     var _isWithdraw: Bool;

     public function new(_ps:PlayState, bombType:Bomb.BombType, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
     {
         super(X, Y, SimpleGraphic);
         _playState = _ps;
         _bombType = bombType;
         switch (_bombType) {
             case Bomb.BombType.Fire:
                //makeGraphic(64, 64, FlxColor.MAGENTA);
                loadGraphic(AssetPaths.SalamanderAnimationSheet__png, true, 64, 64);
                animation.add("walk", [0, 1, 2], 10, false);
                animation.add("withdraw", [3, 4, 5], 10, false);
                _forward = Forward.right;
             case Bomb.BombType.Water:
                //makeGraphic(64, 64, FlxColor.CYAN);
                loadGraphic(AssetPaths.TurtleAnimationSheet__png, true, 64, 64);
                animation.add("walk", [0, 1, 2], 10, false);
                animation.add("withdraw", [3, 4, 5], 10, false);
                _forward = Forward.left;
         }

        animation.finishCallback = onWithdrawFinished;

         bombs = new Array<Bomb>();
         drag.x = 1000000000000;
         drag.y = 1000000000000;
         _speed = 18000;
         _slowSpeed = 12000;
         _pushBackSpeed = 1000;

         _maxBombCount = 3;
         _currentBombCount = 3;

         _isPushingBack = false;
         _pushBackTimer = new FlxTimer();

         myText = new FlxText(110, 100, 500);
        myText.text = "";
        myText.setFormat("assets/font.ttf", 20, FlxColor.WHITE, "center");

        _playState.add(myText);

        // Sound effects
        _sndStep = FlxG.sound.load(AssetPaths.walk__wav);
        _sndWaterStep = FlxG.sound.load(AssetPaths.waterWalk__wav);
        _sndWaterStep.volume = 0.75;
        _sndFireStep = FlxG.sound.load(AssetPaths.fireWalk__wav);
        _sndFireStep.volume = 0.15;
        _sndPlaceBomb = FlxG.sound.load(AssetPaths.placeBomb__wav);
        _sndWithdrawBomb = FlxG.sound.load(AssetPaths.withdrawBomb__wav);
        _sndPushBack = FlxG.sound.load(AssetPaths.thrownBack__wav);

        _isWithdraw = false;

        // Shrink hitbox
        width = 40;
        height = 40;
        offset.set(12, 12);
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
         _sndWithdrawBomb.play();
         _isWithdraw = true;
         animation.play("withdraw");
     }

     function onWithdrawFinished(animName: String) {
         if (animName == "withdraw") {
            _isWithdraw = false;
         }
     }

     function isBombFull(): Bool {
         return _currentBombCount >= _maxBombCount;
     }

     public function movement(elapsed:Float) {

        var tileXmin = Math.floor(y / 64.0);
        var tileXmax = Math.ceil(y / 64.0);
        var tileYmin = Math.floor(x / 64.0);
        var tileYmax = Math.ceil(x / 64.0);
        var _s = _speed;

        var sndTempStep: FlxSound;
        // Check which tile the player is mostly on
        var tileXRound = Math.round(y / 64.0);
        var tileYRound = Math.round(x / 64.0);
        if (_playState.ground[tileXRound][tileYRound].type == Tile.TileType.Water) {
                sndTempStep = _sndWaterStep;
        }
        else if (_playState.ground[tileXRound][tileYRound].type == Tile.TileType.Fire) {
                sndTempStep = _sndFireStep;
        }
        else {
            sndTempStep = _sndStep;
        }

        // 1st player
        if (_bombType == Bomb.BombType.Fire) {

            // Check if player is on opponent's territory
            
            if (_playState.ground[tileXRound][tileYRound].type == Tile.TileType.Water) {
                _s = _slowSpeed;
            }
            
            if (!_isPushingBack) {

                if (FlxG.keys.anyPressed([D]))
                {
                    velocity.set(_s * elapsed, 0);
                    _forward = Forward.right;
                    sndTempStep.play();
                    if (!_isWithdraw) animation.play("walk");
                }
                else if (FlxG.keys.anyPressed([A]))
                {
                    velocity.set(-_s * elapsed, 0);
                    _forward = Forward.left;
                    sndTempStep.play();
                    if (!_isWithdraw) animation.play("walk");
                }
                else if (FlxG.keys.anyPressed([S]))
                {
                    velocity.set(0, _s * elapsed);
                    _forward = Forward.down;
                    sndTempStep.play();
                    if (!_isWithdraw) animation.play("walk");
                }
                else if (FlxG.keys.anyPressed([W]))
                {
                    velocity.set(0, -_s * elapsed);
                    _forward = Forward.up;
                    sndTempStep.play();
                    if (!_isWithdraw) animation.play("walk");
                }
            }

            if (FlxG.keys.anyJustPressed([C])) {
                var minX = Math.floor(x / 64);
                var minY = Math.floor(y / 64);
                var maxX = Math.ceil(x / 64);
                var maxY = Math.ceil(y / 64);

                if (minX < 0) minX = 0;
                if (minY < 0) minY = 0;
                if (maxX >= _playState._tWidth)  maxX = _playState._tWidth - 1;
                if (maxY >= _playState._tHeight)  maxY = _playState._tHeight - 1;

                if (!isBombFull() && (_playState.ground[minY][minX].type == Tile.TileType.FSource ||
                _playState.ground[minY][maxX].type == Tile.TileType.FSource ||
                _playState.ground[maxY][minX].type == Tile.TileType.FSource ||
                _playState.ground[maxY][maxX].type == Tile.TileType.FSource)) {
                    withdrawBombs();
                }
                else {
                    douseBomb();
                }
            }
        }
        
        // 2nd player, doesn't work, don't know why
        if (_bombType == Bomb.BombType.Water) {
            
            if (_playState.ground[tileXRound][tileYRound].type == Tile.TileType.Fire) {
                _s = _slowSpeed;
            }

            if (!_isPushingBack) {

                if (FlxG.keys.anyPressed([RIGHT]))
                {
                    velocity.set(_s * elapsed, 0);
                    _forward = Forward.right;
                    sndTempStep.play();
                    if (!_isWithdraw) animation.play("walk");
                }
                else if (FlxG.keys.anyPressed([LEFT])) 
                {
                    velocity.set(-_s * elapsed, 0);
                    _forward = Forward.left;
                    sndTempStep.play();
                    if (!_isWithdraw) animation.play("walk");
                }
                else if (FlxG.keys.anyPressed([DOWN]))
                {            
                    velocity.set(0, _s * elapsed);
                    _forward = Forward.down;
                    sndTempStep.play();
                    if (!_isWithdraw) animation.play("walk");
                }
                else if (FlxG.keys.anyPressed([UP]))
                {            
                    velocity.set(0, -_s * elapsed);
                    _forward = Forward.up;
                    sndTempStep.play();
                    if (!_isWithdraw) animation.play("walk");
                }
            }

            if (FlxG.keys.anyJustPressed([SLASH])) {
                var minX = Math.floor(x / 64);
                var minY = Math.floor(y / 64);
                var maxX = Math.ceil(x / 64);
                var maxY = Math.ceil(y / 64);

                if (minX < 0) minX = 0;
                if (minY < 0) minY = 0;
                if (maxX >= _playState._tWidth)  maxX = _playState._tWidth - 1;
                if (maxY >= _playState._tHeight)  maxY = _playState._tHeight - 1;

                if (!isBombFull() && (_playState.ground[minY][minX].type == Tile.TileType.WSource ||
                _playState.ground[minY][maxX].type == Tile.TileType.WSource ||
                _playState.ground[maxY][minX].type == Tile.TileType.WSource ||
                _playState.ground[maxY][maxX].type == Tile.TileType.WSource)) {
                    withdrawBombs();
                }
                else {
                    douseBomb();
                }
            }
        }

        // Adjust rotation of sprite
        switch (_forward) {
            case up:
                angle = 0;
            case down:
                angle = 180;
            case right:
                angle = 90;
            case left:
                angle = 270;
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
            if (tempX < 0 || tempY < 0 || tempX >=_playState._tWidth || tempY >=_playState._tHeight ||
             _playState.ground[tempY][tempX].type == Tile.TileType.Unwalkable) {
                return;
            }
            tempBomb = new Bomb(this, _playState, _bombType, tempX*64, tempY*64);
            _playState.add(tempBomb);
            bombs.push(tempBomb);
            _currentBombCount--;
            _sndPlaceBomb.play();
         }
     }

     // Push back function
     public function pushBack(dir:Forward) {
         _isPushingBack = true;
         drag.x = 0;
         drag.y = 0;
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
        _sndPushBack.play();
     }

     function onPushBackComplete(Timer:FlxTimer) : Void {
         _isPushingBack = false;
         drag.x = 1000000000000;
         drag.y = 1000000000000;
     }
 }