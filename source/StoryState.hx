package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.addons.text.FlxTypeText;

/**
    Author: Jinwei Shen
**/
class StoryState extends FlxState {
    var _txtLine1: FlxTypeText;
    var _txtLine2: FlxTypeText;
    var _txtLine3: FlxTypeText;
    var _txtLine4: FlxTypeText;
    var _txtLine5: FlxTypeText;
    var _txtLine6: FlxTypeText;
    var _txtLine7: FlxTypeText;
    var _txtNext: FlxText;
    var _txtSkip: FlxText;

    public var _txtLine: Array<FlxTypeText>;

    override public function create(): Void {
        FlxG.camera.fade(FlxColor.BLACK, 1, true);
        FlxG.mouse.visible = false;

        var _txtWidth: Int = FlxG.width-160;
        _txtLine1 = new FlxTypeText(80, 100, _txtWidth, "There was once a land that was ripe for reptiles and amphibians alike.", 20, true);
        _txtLine1.color = FlxColor.CYAN;

        _txtLine2 = new FlxTypeText(80, 40, _txtWidth, "A land where the dreams of all the little turtles and salamanders of the world could come to fruition.", 20, true);
        _txtLine2.y = _txtLine1.height + _txtLine1.y + 20;
        _txtLine2.color = FlxColor.CYAN;

        _txtLine3 = new FlxTypeText(80, 40, _txtWidth, "Unfortunately, it was the dream of one such turtle to drive all the salamanders from this slice of paradise.", 20, true);
        _txtLine3.y = _txtLine2.height*2 + _txtLine2.y + 20;
        _txtLine3.color = FlxColor.CYAN;

        _txtLine4 = new FlxTypeText(80, 40, _txtWidth, "He'd wander around, dousing the ground with water to keep the salamanders away.", 20, true);
        _txtLine4.y = _txtLine3.height*2 + _txtLine3.y + 20;
        _txtLine4.color = FlxColor.CYAN;

        _txtLine5 = new FlxTypeText(80, 40, _txtWidth, "He was the turtle the salamanders warned their children about.", 20, true);
        _txtLine5.y = _txtLine4.height + _txtLine4.y + 20;
        _txtLine5.color = FlxColor.CYAN;

        _txtLine6 = new FlxTypeText(80, 40, _txtWidth, "However, one day a little salamander was born who had a dream of his own: to drive all the turtles away from this land.", 20, true);
        _txtLine6.y = _txtLine5.height + _txtLine5.y + 20;
        _txtLine6.color = FlxColor.CYAN;

        _txtLine7 = new FlxTypeText(80, 40, _txtWidth, "So this salamander set out with his flames to fight back against the turtle and claim this land for the amphibians once and for all.", 20, true);
        _txtLine7.y = _txtLine6.height*2 + _txtLine6.y + 20;
        _txtLine7.color = FlxColor.CYAN;

        _txtNext = new FlxText(0, 0, "Press Enter to Start", 14);
        _txtNext.x = FlxG.width - _txtNext.width - 30;
        _txtNext.y = FlxG.height - _txtNext.height - 10;
        _txtNext.visible = false;
        _txtNext.color = FlxColor.RED;

        _txtSkip = new FlxText(0, 0, "Press Space to Skip", 14);
        _txtSkip.screenCenter(FlxAxes.X);
        _txtSkip.y = FlxG.height - _txtSkip.height - 10;
        _txtSkip.color = FlxColor.YELLOW;

        add(_txtLine1);
        add(_txtLine2);
        add(_txtLine3);
        add(_txtLine4);
        add(_txtLine5);
        add(_txtLine6);
        add(_txtLine7);
        add(_txtNext);
        add(_txtSkip);

        _txtLine = [_txtLine2, _txtLine3, _txtLine4, _txtLine5, _txtLine6, _txtLine7];
        _txtLine1.skipKeys = ["SPACE"];
        _txtLine1.start(0.05, false, false, null, onComplete.bind(0));

        super.create();
    }

    override public function update(elapsed: Float): Void {
        super.update(elapsed);

        if (_txtNext.visible && FlxG.keys.anyPressed([ENTER])) {
            FlxG.camera.fade(FlxColor.BLACK, 0.7, false, function(){
                FlxG.switchState(new PlayState());
            });
        }
    }
    function onComplete(index: Int): Void {
        if (index < 6) {
            _txtLine[index].skipKeys = ["SPACE"];
            _txtLine[index].start(0.05, false, false, null, onComplete.bind(index+1));
        } else {
            _txtSkip.visible = false;
            _txtNext.visible = true;
        }
    }
}