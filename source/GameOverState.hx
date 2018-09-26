package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

/**
    Author: Jinwei Shen
**/
class GameOverState extends FlxState {
    var _score1: Int = 0; // slamander
    var _score2: Int = 0; // turtle
    var _result: Int = 0; // 0 - draw; 1 - salamander wins; 2 - turtle wins
    var _txtTitle: FlxText;
    var _txtScore: FlxText;
    var _txtHighScore: FlxText;
    var _highScore: Int;

    var _btnRetry: FlxButton;
    var _btnMenu: FlxButton;

    public function new(Score1: Int, Score2: Int) {
        _score1 = Score1;
        _score2 = Score2;
        super();
    }

    override public function create(): Void {
        FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
        _txtTitle = new FlxText(0, 150, "Draw!", 30);
        if (_score1 == _score2) {
            _txtTitle.text = "Draw!";
            _highScore = _score1;
        } else if (_score1 > _score2) {
            _txtTitle.text = "Salamander Wins!";
            _txtTitle.color = FlxColor.RED;
            _highScore = _score1;
        } else {
            _txtTitle.text = "Turtle Wins!";
            _txtTitle.color = FlxColor.BLUE;
            _highScore = _score2;
        }
        _txtTitle.screenCenter(FlxAxes.X);
        add(_txtTitle);

        _txtScore = new FlxText(0, 0, "Score   "+_score1+" : "+_score2, 22);
        _txtScore.screenCenter();
        _txtScore.y -= 80;
        add(_txtScore);

        var highScore = checkHighScore(_highScore);
        _txtHighScore = new FlxText(0, 0, "High Score:    "+highScore, 22);
        _txtHighScore.screenCenter();
        add(_txtHighScore);

        var labelSize: Int = 16;
        _btnRetry = new FlxButton(0, 0, "Play Again", clickRetry);
        _btnRetry.scale.set(2,2);
        _btnRetry.updateHitbox();
        _btnRetry.screenCenter();
        _btnRetry.y += 120;
        _btnRetry.label.fieldWidth = _btnRetry.width;
        _btnRetry.label.size = labelSize;
        _btnRetry.label.alignment = CENTER;
        _btnRetry.label.offset.y -= 5;
        add(_btnRetry);

        _btnMenu = new FlxButton(0, 0, "Main Menu", clickMenu);
        _btnMenu.scale.set(2,2);
        _btnMenu.updateHitbox();
        _btnMenu.screenCenter();
        _btnMenu.y = _btnRetry.y + 80;
        _btnMenu.label.fieldWidth = _btnMenu.width;
        _btnMenu.label.size = labelSize;
        _btnMenu.label.alignment = CENTER;
        _btnMenu.label.offset.y -= 5;
        add(_btnMenu);

        super.create();
    }

    function checkHighScore(Score: Int): Int {
        var _hi: Int = Score;
        var _save: FlxSave = new FlxSave();
        if (_save.bind("Nesting_Gounds")) {
            if (_save.data.hiscore != null && _save.data.hiscore > _hi) {
                _hi = _save.data.hiscore;
            } else {
                _save.data.hiscore = _hi;
            }
        }
        _save.close();
        return _hi;
    }

    function clickRetry(): Void {
        FlxG.camera.fade(FlxColor.BLACK, 0.7, false, function(){
            FlxG.switchState(new PlayState());
        });
    }

    function clickMenu(): Void {
        FlxG.camera.fade(FlxColor.BLACK, 0.7, false, function(){
            FlxG.switchState(new MenuState());
        });
    }
}