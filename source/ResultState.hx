package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxAxes;

class ResultState extends FlxState{

    var _content: String;
    var _txtTitle: FlxText;
    var _btnBack: FlxButton;

    public function new(c: String) {
        super();
        _content = c;
    }

    override public function create(): Void {
        _txtTitle = new FlxText(0, 50, 500, _content, 30);
        _txtTitle.alignment = CENTER;
        _txtTitle.screenCenter(FlxAxes.X);
        add(_txtTitle);

        _btnBack = new FlxButton(0, FlxG.height/2 + 40, "Back", clickBack);
        _btnBack.screenCenter(FlxAxes.X);
        add(_btnBack);

        super.create();
    }

    function clickBack(): Void {
        FlxG.switchState(new MenuState());
    }
}