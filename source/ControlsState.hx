package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

/**
    Author: Jinwei Shen
**/
class ControlsState extends FlxState {
    var _txtTitle: FlxText;

    var _txtP1: FlxText;
    var _txtP2: FlxText;
    var _txtMove: FlxText;
    var _moveCtrl1: FlxText;
    var _moveCtrl2: FlxText;
    var _txtDouse: FlxText;
    var _douseCtrl1: FlxText;
    var _douseCtrl2: FlxText;
    var _txtWithdraw: FlxText;
    var _withdrawCtrl: FlxText;
    var _txtGoal: FlxText;
    var _winCondition: FlxText;

    var _btnBack: FlxButton;

    override public function create(): Void {
        FlxG.mouse.visible = true;
        FlxG.camera.fade(FlxColor.BLACK, 0.5, true);

        _txtTitle = new FlxText(0, 150, "Controls", 30);
        _txtTitle.alignment = CENTER;
        _txtTitle.screenCenter(FlxAxes.X);
        _txtTitle.color = FlxColor.YELLOW;
        add(_txtTitle);

        _txtP1 = new FlxText(0, _txtTitle.y+100, "Player 1", 22);
        _txtP1.screenCenter(FlxAxes.X);
        _txtP1.x -= 200;
        _txtP1.alignment = CENTER;
        _txtP1.color = FlxColor.RED;
        add(_txtP1);

        _txtP2 = new FlxText(0, _txtTitle.y+100, "Player 2", 22);
        _txtP2.screenCenter(FlxAxes.X);
        _txtP2.x += 200;
        _txtP2.alignment = CENTER;
        _txtP2.color = FlxColor.BLUE;
        add(_txtP2);

        _txtMove = new FlxText(100, _txtP1.y+60, "Movement", 20);
        _txtMove.color = FlxColor.CYAN;
        add(_txtMove);

        _moveCtrl1 = new FlxText(_txtP1.x, _txtMove.y, "W, A, S, D", 20);
        _moveCtrl1.alignment = CENTER;
        _moveCtrl1.color = FlxColor.MAGENTA;
        add(_moveCtrl1);

        _moveCtrl2 = new FlxText(_txtP2.x-10, _txtMove.y, "Arrow Keys", 20);
        _moveCtrl2.alignment = CENTER;
        _moveCtrl2.color = FlxColor.MAGENTA;
        add(_moveCtrl2);

        _txtDouse = new FlxText(_txtMove.x, _txtMove.y+60, "Douse Bomb", 20);
        _txtDouse.color = FlxColor.CYAN;
        add(_txtDouse);

        _douseCtrl1 = new FlxText(_txtP1.x+40, _txtDouse.y, "C", 20);
        _douseCtrl1.alignment = CENTER;
        _douseCtrl1.color = FlxColor.MAGENTA;
        add(_douseCtrl1);

        _douseCtrl2 = new FlxText(_txtP2.x+40, _txtDouse.y, "/", 20);
        _douseCtrl2.alignment = CENTER;
        _douseCtrl2.color = FlxColor.MAGENTA;
        add(_douseCtrl2);

        _txtWithdraw = new FlxText(100, _txtDouse.y+60, "Withdraw Bomb", 20);
        _txtWithdraw.color = FlxColor.CYAN;
        add(_txtWithdraw);

        _withdrawCtrl = new FlxText(_txtP1.x-20, _txtWithdraw.y, 'Press the same key as "Douse" at spawn location', 20);
        _withdrawCtrl.color = FlxColor.MAGENTA;
        add(_withdrawCtrl);

        _txtGoal = new FlxText(100, _txtWithdraw.y+60, "Winning Condition", 20);
        _txtGoal.color = FlxColor.CYAN;
        add(_txtGoal);

        _winCondition = new FlxText(_withdrawCtrl.x, _txtGoal.y, "The player who occupies the most territories win", 20);
        _winCondition.color = FlxColor.MAGENTA;
        add(_winCondition);

        _btnBack = new FlxButton(0, 0, "Got it", clickBack);
        _btnBack.scale.set(2,2);
        _btnBack.updateHitbox();
        _btnBack.screenCenter();
        _btnBack.y = FlxG.height - 150;
        _btnBack.label.fieldWidth = _btnBack.width;
        _btnBack.label.size = 16;
        _btnBack.label.alignment = CENTER;
        _btnBack.label.offset.y -= 5;
        add(_btnBack);

        super.create();
    }

    function clickBack(): Void {
        FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function(){
            FlxG.switchState(new MenuState());
        });
    }
}