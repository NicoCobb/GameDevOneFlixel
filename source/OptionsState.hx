package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxAxes;

class OptionsState extends FlxState {
    var _btnBack: FlxButton;

    override public function create(): Void {
        _btnBack = new FlxButton(0, 0, "Back", clickBack);
        _btnBack.screenCenter();
        add(_btnBack);
        super.create();
    }

    function clickBack(): Void {
        FlxG.switchState(new MenuState());
    }
}