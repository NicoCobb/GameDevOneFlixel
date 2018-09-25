package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

class HUD extends FlxTypedGroup<FlxSprite> {
    var _txtTimer: FlxText;
    var _txtBomb1: FlxText;
    var _txtBomb2: FlxText;
    var _txtTerritory1: FlxText;
    var _txtTerritory2: FlxText;

    public function new(): Void {
        super();

        // Timer
        _txtTimer = new FlxText(0, 0, 0, "03 : 00", 22);
        _txtTimer.color = FlxColor.BLACK;
        _txtTimer.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        _txtTimer.alignment = CENTER;
        _txtTimer.screenCenter(FlxAxes.X);

        // Bomb count for p1
        _txtBomb1 = new FlxText(50, 0, 0, "Bomb left: 3", 14);
        _txtBomb1.y = FlxG.height - _txtBomb1.height;
        _txtBomb1.color = FlxColor.RED;
        _txtBomb1.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);

        // Bomb count for p2
        _txtBomb2 = new FlxText(0, _txtBomb1.y, 0, "Bomb left: 3", 14);
        _txtBomb2.x = FlxG.width - _txtBomb2.width - 50;
        _txtBomb2.color = FlxColor.BLUE;
        _txtBomb2.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);

        // Territory count for p1
        _txtTerritory1 = new FlxText(0, 0, 0, "P1 Territory: 0", 14);
        _txtTerritory1.screenCenter(FlxAxes.X);
        _txtTerritory1.x -= _txtTerritory1.width + 50;
        _txtTerritory1.y = _txtTimer.y + _txtTimer.height + 2;
        _txtTerritory1.color = FlxColor.RED;
        _txtTerritory1.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);

        // Territory count for p2
        _txtTerritory2 = new FlxText(0, 0, 0, "P2 Territory: 0", 14);
        _txtTerritory2.screenCenter(FlxAxes.X);
        _txtTerritory2.x += _txtTerritory2.width + 50;
        _txtTerritory2.y = _txtTimer.y + _txtTimer.height + 2;
        _txtTerritory2.color = FlxColor.BLUE;
        _txtTerritory2.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);

        add(_txtTimer);
        add(_txtBomb1);
        add(_txtBomb2);
        add(_txtTerritory1);
        add(_txtTerritory2);
    }

    public function updateHUD(Bomb1: Int, Bomb2: Int, Territory1: Int, Territory2: Int, timeLeft: Float): Void {
        _txtBomb1.text = "Bomb left: " + Bomb1;
        _txtBomb2.text = "Bomb left: " + Bomb2;
        _txtTerritory1.text = "P1 Territory: " + Territory1;
        _txtTerritory2.text = "P2 Territory: " + Territory2;

        var min = Math.floor(timeLeft / 60);
        var sec = Math.floor(timeLeft % 60);
        if (sec > 9) {
            _txtTimer.text = "0" + min + " : " + sec;
        }
        else {
            _txtTimer.text = "0" + min + " : 0" + sec;
        }
    }
}