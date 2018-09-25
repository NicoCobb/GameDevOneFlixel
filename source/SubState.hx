package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;


/**
    Author: Jinwei Shen
**/
class SubState extends FlxSubState {
    var _btnResume: FlxButton;
    var _btnMenu: FlxButton;
    var _PlayState: PlayState;

    override public function create(): Void {
        super.create();
        _PlayState = cast _parentState;
        _btnResume = new FlxButton(0, 0, "Resume", clickResume);
        _btnResume.screenCenter();
        add(_btnResume);

        _btnMenu = new FlxButton(0, 0, "Main Menu", clickMenu);
        _btnMenu.screenCenter();
        _btnMenu.y += 2 * _btnResume.height;
        add(_btnMenu);
    }

    function clickResume(): Void {
        _PlayState._timer.active = true;
        close();
    }

    function clickMenu(): Void {
        FlxG.switchState(new MenuState());
    }
}