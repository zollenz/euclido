package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.system.FlxSound;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	// Primitive vars
	private var counter:Int;

	// Audio objects
	private var _sound1:FlxSound;
	private var _sound2:FlxSound;
	private var _sound3:FlxSound;
	private var _sound4:FlxSound;

	// Graphic objects
	private var _canvas:FlxSprite;

	override public function create():Void
	{
		// Init vars
		counter = 0;
		// Init sound
		_sound1 = FlxG.sound.load("assets/sounds/808_bd.wav", 1.0);
		_sound2 = FlxG.sound.load("assets/sounds/808_sd.wav", 1.0);		
		_sound3 = FlxG.sound.load("assets/sounds/808_cl_hh.wav", 1.0);
		_sound4 = FlxG.sound.load("assets/sounds/808_op_hh.wav", 1.0);
		// Init grapbics
		_canvas = new FlxSprite();
		_canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(_canvas);
		super.create();
	}
	
	override public function destroy():Void
	{
		// Destroy audio objects
		_sound1.destroy();
		_sound2.destroy();
		_sound3.destroy();		
		_sound4.destroy();
		_sound1 = null;
		_sound2 = null;
		_sound3 = null;		
		_sound4 = null;
		// Destroy graphic objects
		_canvas.destroy();
		_canvas = null;

		super.destroy();
	}

	override public function update():Void
	{
		// trace("Delta time: " + FlxG.elapsed);

		if (counter % 50 == 0 || counter % 45 == 0) {
			_sound1.play(true);	
		}
		
		if (counter % 100 == 0) {
			_sound2.play(true);	
		}

		if (counter % 43 == 0) {
			_sound3.play(true);	
		}

		if (counter % 72 == 0) {
			_sound4.play(true);	
		}

		++counter;
		super.update();
	}
}