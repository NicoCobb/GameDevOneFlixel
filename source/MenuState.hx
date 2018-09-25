package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flash.system.System;

/**
    Author: Jinwei Shen
**/
class MenuState extends FlxState {
    var _txtTitle: FlxText;
    var _btnStart: FlxButton;
    var _btnOptions: FlxButton;
    var _btnQuit: FlxButton;

    override public function create(): Void {
        FlxG.mouse.visible = false;
        FlxG.cameras.bgColor = 0xff131c1b;
        _txtTitle = new FlxText(0, 150, 500, "Project 1", 30);
        _txtTitle.alignment = CENTER;
        _txtTitle.screenCenter(FlxAxes.X);
        add(_txtTitle);

        var yOffset: Int = 250;
        var labelSize: Int = 16;
        var btnArray: Array<FlxButton> = [_btnStart, _btnOptions, _btnOptions];
        _btnStart = new FlxButton(0, FlxG.height-yOffset, "Start", clickStart);
        _btnStart.scale.set(2,2);
        _btnStart.updateHitbox();
        _btnStart.screenCenter(FlxAxes.X);
        _btnStart.label.fieldWidth = _btnStart.width;
        _btnStart.label.size = labelSize;
        _btnStart.label.alignment = CENTER;
        _btnStart.label.offset.y -= 5;
        add(_btnStart);

        yOffset -= 70;
        _btnOptions = new FlxButton(0, FlxG.height-yOffset, "Options", clickOptions);
        _btnOptions.scale.set(2,2);
        _btnOptions.updateHitbox();
        _btnOptions.screenCenter(FlxAxes.X);
        _btnOptions.label.fieldWidth = _btnOptions.width;
        _btnOptions.label.size = labelSize;
        _btnOptions.label.alignment = CENTER;
        _btnOptions.label.offset.y -= 5;
        add(_btnOptions);

        yOffset -= 70;
        _btnQuit = new FlxButton(0, FlxG.height-yOffset, "Quit", clickQuit);
        _btnQuit.scale.set(2,2);
        _btnQuit.updateHitbox();
        _btnQuit.screenCenter(FlxAxes.X);
        _btnQuit.label.fieldWidth = _btnQuit.width;
        _btnQuit.label.size = labelSize;
        _btnQuit.label.alignment = CENTER;
        _btnQuit.label.offset.y -= 5;
        add(_btnQuit);

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
            FlxG.switchState(new StoryState());
        });
    }

    function clickOptions(): Void {
        FlxG.camera.fade(FlxColor.BLACK, 0.7, false, function(){
            FlxG.switchState(new OptionsState());
        });
    }

    function clickQuit(): Void {
        System.exit(0);
    }
}