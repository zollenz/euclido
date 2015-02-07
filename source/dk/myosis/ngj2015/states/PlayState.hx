package dk.myosis.ngj2015.states;

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
	private var _counter:Int;
	private var _visualizerRadius:Float;

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
		_counter = 0;
		_visualizerRadius = 0.25 * FlxG.height;
		// Init sound
		_sound1 = FlxG.sound.load("assets/sounds/808_bd.wav", 1.0);
		_sound2 = FlxG.sound.load("assets/sounds/808_sd.wav", 1.0);		
		_sound3 = FlxG.sound.load("assets/sounds/808_cl_hh.wav", 1.0);
		_sound4 = FlxG.sound.load("assets/sounds/808_op_hh.wav", 1.0);
		// Init grapbics
		_canvas = new FlxSprite();
		_canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(_canvas);
		var lineStyle = { color: FlxColor.RED, thickness: 2.0 };
		var fillStyle = { color: FlxColor.BLUE, alpha: 0.5 };
		_canvas.drawCircle(0.5 * FlxG.width, 0.5 * FlxG.height, _visualizerRadius, FlxColor.BLACK, lineStyle);
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
		// var lineStyle = { color: FlxColor.CHARTREUSE, thickness: 2.0 };
		// _canvas.drawLine(0, 0, 200, 200, lineStyle);

		if (_counter % 60 == 0 || _counter % 45 == 0) {
			_sound1.play(true);	
		}
		
		if (_counter % 120 == 0) {
			_sound2.play(true);	
		}

		if (_counter % 15 == 0) {
			_sound3.play(true);	
		}

		if (_counter % 120 == 0) {
			_sound4.play(true);	
		}

		++_counter;
		super.update();
	}
}