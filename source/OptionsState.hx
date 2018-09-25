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
class OptionsState extends FlxState {
    var _btnBack: FlxButton;

    override public function create(): Void {
        FlxG.mouse.visible = false;
        _btnBack = new FlxButton(0, 0, "Back", clickBack);
        _btnBack.screenCenter();
        add(_btnBack);
        super.create();
    }

    function clickBack(): Void {
        FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function(){
            FlxG.switchState(new MenuState());
        });
    }
}