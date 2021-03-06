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
        FlxG.mouse.visible = true;
        _PlayState = cast _parentState;

        var labelSize: Int = 16;
        _btnResume = new FlxButton(0, 0, "Resume", clickResume);
        _btnResume.scale.set(2,2);
        _btnResume.updateHitbox();
        _btnResume.screenCenter();
        _btnResume.label.fieldWidth = _btnResume.width;
        _btnResume.label.size = labelSize;
        _btnResume.label.alignment = CENTER;
        _btnResume.label.offset.y -= 5;
        add(_btnResume);

        _btnMenu = new FlxButton(0, 0, "Main Menu", clickMenu);
        _btnMenu.scale.set(2,2);
        _btnMenu.updateHitbox();
        _btnMenu.screenCenter();
        _btnMenu.y = _btnResume.y + 100;
        _btnMenu.label.fieldWidth = _btnMenu.width;
        _btnMenu.label.size = labelSize;
        _btnMenu.label.alignment = CENTER;
        _btnMenu.label.offset.y -= 5;
        add(_btnMenu);
    }

    override public function update(elapsed: Float): Void {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE) {
            clickResume();
        }
    }

    function clickResume(): Void {
        _PlayState._timer.active = true;
        close();
    }

    function clickMenu(): Void {
        FlxG.camera.fade(FlxColor.BLACK, 0.7, false, function(){
            FlxG.switchState(new MenuState());
        });
    }
}