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
class MenuState extends FlxState {
    var _txtTitle: FlxText;
    var _btnStart: FlxButton;
    var _btnOptions: FlxButton;

    override public function create(): Void {
        FlxG.mouse.visible = false;
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

        // Play background music
		if (FlxG.sound.music == null) {
			FlxG.sound.playMusic(AssetPaths.simpleSong__ogg, 0.5, true);
		}

        super.create();
    }

    function clickStart(): Void {
        /*
            Fade effect after clicking the button
            param: color, duration, fadefrom/to bool,
        */
        FlxG.camera.fade(FlxColor.BLACK, 1, false, function(){
            FlxG.switchState(new PlayState());
        });

    }

    function clickOptions(): Void {
        FlxG.camera.fade(FlxColor.BLACK, 0.7, false, function(){
            FlxG.switchState(new OptionsState());
        });
    }
}