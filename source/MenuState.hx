package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxAxes;

class MenuState extends FlxState {
    var _txtTitle: FlxText;
    var _btnStart: FlxButton;
    var _btnOptions: FlxButton;

    override public function create(): Void {
        _txtTitle = new FlxText(0, 50, 500, "Project 1", 30);
        _txtTitle.alignment = CENTER;
        _txtTitle.screenCenter(FlxAxes.X);
        add(_txtTitle);

        _btnStart = new FlxButton(0, FlxG.height/2 + 40, "Start", clickStart);
        _btnStart.screenCenter(FlxAxes.X);
        add(_btnStart);

        _btnOptions = new FlxButton(0, FlxG.height/2 + 70, "Options", clickOptions);
        _btnOptions.screenCenter(FlxAxes.X);
        add(_btnOptions);

        super.create();
    }

    function clickStart(): Void {
        FlxG.switchState(new PlayState());
    }

    function clickOptions(): Void {
        FlxG.switchState(new OptionsState());
    }
}